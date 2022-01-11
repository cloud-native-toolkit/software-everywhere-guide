# Cluster Configuration

<!--- cSpell:ignore jsonpath APIKEY APIURL ENCRPT pactbroker -->

Within the created Kubernetes or OpenShift cluster there are a number secrets and config maps that are either provided by the IBM Cloud public environment and utilized by the Terraform scripts or are created during the Terraform provisioning process.

Many of these secrets and config maps are also used by the pipeline scripts, so you may need to update them as you change passwords.

## Namespaces

The Iteration Zero scripts create four namespaces that are used by the components deployed into the cluster: `tools`, `dev`, `test`, and `staging`. The actual names used for the namespaces are provided in Terraform variables with the defaults being those listed. The variables are then passed into the namespaces module in `stage1-namespaces.tf`.

## Provided resources

### TLS secret

When the cluster is created, a secret containing the TLS certs for the ingress subdomain is provided in the `default` namespace. The the name of the secret is based off of the cluster name with some rules applied to limit the length and replace disallowed characters.

!!!Note
    To avoid issues with the naming conventions for the secret, the Iteration Zero scripts look for the secret that has a `tls.key` value: `kubectl get secrets -o jsonpath='{.items[?(@.data.tls\.key != "")].metadata.name}'`.  Ideally this would be identified using a label and a selector...

During the Iteration Zero process, the TLS secret is copied into each of the four namespaces created and used by the Iteration Zero processes.

### Pull secrets

Pull secrets for the IBM Cloud Image Registry are generated in the cluster as part of the Iteration Zero process to prepare the namespaces. The secrets are initially created in the `default` namespace with the following names:

- `default-icr-io`
- `default-{region}-icr-io`

During the namespace preparation process, the pull secrets are copied into the different namespaces with `default-` prefix dropped. E.g.

- `icr-io`
- `{region}-icr-io`

The pull secrets are also added to the `default` service account in each of the namespaces. As a result, it is not necessary to directly reference the pull secret as long as the pod runs under the default service account.

## Created resources

The following resources are all created during the Iteration Zero provisioning process. These resources
are used generally to expose the config of the installed tools but specifically used by the CI pipeline ([Jenkins](../../reference/tools/jenkins.md), [Tekton](../../reference/tools/tekton.md), etc.) to interact with the deployed tools. The resources are bound as optional environment variables in the containers used within the pipeline so if a particular tool has not been installed the associated environment variables won't be set. For example:

```yaml
  envFrom:
    - configMapRef:
        name: pactbroker-config
        optional: true
    - configMapRef:
        name: sonarqube-config
        optional: true
    - secretRef:
        name: sonarqube-access
        optional: true
```

### IBM Cloud config

The Iteration Zero script creates a config map and secret named `ibmcloud-config` and `ibmcloud-access`
in the `default` namespace that contains the relevant configuration values for the cluster within the IBM  Cloud account. The config map and secret are copied into each of the Iteration Zero namespaces as the namespaces are created.

#### `ibmcloud-config` config map

The following values are collected:

- CLUSTER_TYPE - the type of cluster (kubernetes or openshift)
- APIURL - the api url used to connect to the IBM Cloud environment
- SERVER_URL - the server url used to connect to the cluster, particularly for OpenShift
- RESOURCE_GROUP - the IBM Cloud resource group where the cluster has been installed
- REGISTRY_URL - the url to the image registry
- REGISTRY_NAMESPACE - the namespace within the image registry where images will be stored
- REGION - the IBM Cloud region where where the cluster has been installed
- CLUSTER_NAME - the name of the cluster
- INGRESS_SUBDOMAIN - the subdomain for the cluster to use in building ingress urls
- TLS_SECRET_NAME - the name of the secret that contains the TLS certificate information

#### `ibmcloud-access` secret

The following values are collected:

- APIKEY - the IBM Cloud apikey used to access the environment

### ArgoCD config

#### `argocd-config` config map

- ARGOCD_URL - the url of the ArgoCD ingress

#### `argocd-access` secret

- ARGOCD_PASSWORD - the password for the argocd user
- ARGOCD_USER - the user id of the argocd user

### Artifactory config

#### `artifactory-config` config map

- ARTIFACTORY_URL - the url for the Artifactory ingress

#### `artifactory-access` config map

- ARTIFACTORY_USER - the user name of the admin user
- ARTIFACTORY_PASSWORD - the password for the admin user
- ARTIFACTORY_ENCRPT - the encrypted password for the admin user. This value is initially blank
and must be updated after the value is generated in the UI
- ARTIFACTORY_ADMIN_ACCESS_USER - the admin access user
- ARTIFACTORY_ADMIN_ACCESS_PASSWORD - the admin access password

### Jenkins config

#### `jenkins-config` config map

- JENKINS_HOST - the host name of the Jenkins ingress
- JENKINS_URL - the url of the Jenkins ingress

#### `jenkins-access` secret

- api_token - the Jenkins api token
- host - the host name of the Jenkins ingress
- url - the url of the Jenkins ingress
- username - the Jenkins user name
- password - the Jenkins password

### PactBroker config

#### `pactbroker-config` config map

- PACTBROKER_URL - the url of the Pact Broker ingress

### SonarQube config

#### `sonarqube-config` config map

- SONARQUBE_URL - the url of the SonarQube ingress

#### `sonarqube-access` secret

- SONARQUBE_USER - the user name of the SonarQube user
- SONARQUBE_PASSWORD - the password of the SonarQube user
