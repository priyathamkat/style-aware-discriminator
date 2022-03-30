#!/usr/bin/env python
import argparse
import os

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import seaborn as sns
import torch
from sklearn.manifold import TSNE

import data
from model import StyleAwareDiscriminator
from model.augmentation import SimpleTransform


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--checkpoint", required=True)
    parser.add_argument("--target-dataset", required=True)
    parser.add_argument("--seed", type=int)
    parser.add_argument("--title")
    parser.add_argument("--legends", nargs="+", default=[])
    parser.add_argument("--batch-size", type=int, default=32)
    args = parser.parse_args()
    assert os.path.isfile(args.checkpoint)
    assert os.path.isdir(args.target_dataset)
    return args


def plot_tsne(model, dataset, seed, filename, title, legends, batch_size):
    dataset.return_target = True
    device = model.device
    loader = torch.utils.data.DataLoader(dataset, batch_size)

    style_codes, targets = [], []
    for batch in loader:
        image, target = batch
        image = image.to(device)

        style_code = model.D_ema(image, command="encode")

        style_codes.append(style_code.cpu().numpy())
        targets.append(target.numpy())

    style_codes = np.concatenate(style_codes)
    targets = np.concatenate(targets)

    prototypes = model.prototypes_ema[0].weight.cpu().numpy()
    proto_targets = np.zeros((prototypes.shape[0],), dtype=np.int32) - 1

    style_codes = np.vstack((style_codes, prototypes))
    targets = np.concatenate((targets, proto_targets))
    labels = np.unique(targets)
    print(style_codes.shape, targets.shape)

    tsne = TSNE(n_components=2, random_state=seed)
    z = tsne.fit_transform(style_codes)

    df = pd.DataFrame()
    df["y"] = targets
    df["y"] = df["y"].apply(str)
    if len(legends) + 1 == len(labels):
        for i, label in enumerate(legends):
            df.loc[df["y"] == str(i), "y"] = label
    df.loc[df["y"] == "-1", "y"] = "prototypes"
    df["comp-1"] = z[:, 0]
    df["comp-2"] = z[:, 1]
    sns.scatterplot(
        x="comp-1", y="comp-2", hue=df.y.tolist(),
        palette=sns.color_palette("hls", len(labels)),
        data=df,
    ).set(title="T-SNE projection" if title is None else title)
    plt.axis("off")
    plt.savefig(filename)
    plt.close("all")


def main():
    args = parse_args()
    checkpoint = torch.load(args.checkpoint, map_location="cpu")
    opts = checkpoint["options"]
    print(opts)

    torch.backends.cuda.matmul.allow_tf32 = False
    torch.backends.cudnn.allow_tf32 = False
    torch.backends.cudnn.benchmark = False

    model = StyleAwareDiscriminator(opts)
    model.load(checkpoint)
    del model.optimizers

    transform = SimpleTransform(opts.image_size)
    target_dataset = data.get_dataset(args.target_dataset, transform)

    out_dir = os.path.join(opts.run_dir, "tsne")
    os.makedirs(out_dir, exist_ok=True)
    filename = os.path.join(out_dir, "tsne.png")
    plot_tsne(
        model=model,
        dataset=target_dataset,
        seed=args.seed,
        filename=filename,
        title=args.title,
        legends=args.legends,
        batch_size=args.batch_size,
    )


if __name__ == "__main__":
    main()
