## Usage

For a general usage documentation, please refer to the following link: [Valkey-Operator Documentation](docs/)

[Helm](https://helm.sh) must be installed to use the charts.  Please refer to
Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:

```shell
helm repo add andinod https://andinod.github.io/valkey-operator
```

If you had already added this repo earlier, run `helm repo update` to retrieve
the latest versions of the packages.  You can then run `helm search repo
andinod` to see the charts.

To install the valkey-operator chart:

    helm upgrade --install valkey-operator andinod/valkey-operator -n valkey-operator-system --create-namespace

To uninstall the chart:

    helm uninstall valkey-operator -n valkey-operator-system
