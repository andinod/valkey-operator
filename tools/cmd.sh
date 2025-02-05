# For the creation
operator-sdk init --plugins helm --group=valkey --domain=andino.io --project-name=valkey --version v1alpha1 --kind Valkey

# After file customization and edition, previously login: docker login quay.io
# After creation remember to make the repo public
make docker-build docker-push IMG=quay.io/$USERNAME/valkey-operator:v0.0.1


# To deploy the operator
make deploy IMG=quay.io/$USERNAME/valkey-operator:v0.0.1

# After deployment: kubectl get all -n valkey-operator-system
# To change the name of the namespace: config/default/kustomization.yaml

# To undeploy
make undeploy IMG=quay.io/$USERNAME/valkey-operator:v0.0.1
