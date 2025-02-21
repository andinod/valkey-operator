# Valkey Operator

-[License](https://www.apache.org/licenses/LICENSE-2.0.txt)
-[Release](https://github.com/andinod/valkey-operator/releases)

## Introduction

This Valkey Operator it is a Helm Operator based on the Bitnami Valkey Helm Chart, so the operator it is just a wrapper with all the features that the original Bitnami Valkey Helm Chart offers.

## Features

- Wrapper of the Bitnami Valkey Helm Chart
- Helm Chart 

## Installation

### Prerequisites

- Kubernetes v1.32.0+

### Using Helm

Deploy using Helm (version 3.8.0 or later). In the following link you will get the proper instructions [Helm Installation](https://andinod.github.io/valkey-operator/).

```bash
helm upgrade --install my-valkey-operator https://andinod.github.io/valkey-operator/charts/valkey-operator
```

### Using Makefile and Development

For the development or the use of a local installation using the Makefile, please refer to the tools/cmd.sh file, and check the used options.


### Versioning and Release

A new docker image, bundle and helm chart will be created each time a tag starting with v is pushed to the main branch.


### Building the helm chart

We use [helmify](https://github.com/arttor/helmify) to generate Helm chart from kustomize rendered manifests. To update
the chart run:

```shell
make helm
```

The chart will be created/updated in `charts/valkey-operator` path

## Contributing

Contributions are warmly welcomed. Feel free to submit issues or pull requests.

## Links used for construction

As an additional information is added the list of links for documentation and instructions:

-[Step-by-Step Guide to Hosting Your Own Helm Chart Registry on GitHub Pages](https://medium.com/@blackhorseya/step-by-step-guide-to-hosting-your-own-helm-chart-registry-on-github-pages-c37809a1d93f)
-[Publish a helm chart for your Kubernetes operator](https://medium.com/@therealak12/publish-a-helm-chart-for-your-kubernetes-operator-ffeb9f998e5a)
-[Chart Releaser Action to Automate GitHub Page Charts](https://helm.sh/docs/howto/chart_releaser_action/)
-[A journey of a Helm operator to OperatorHub.io and back again](https://labs.consol.de/development/2021/05/03/helm_based_operator.html)
-[Helm Operator Tutorial](https://sdk.operatorframework.io/docs/building-operators/helm/tutorial/)

## License

This project is licensed under the [Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0.txt).
