# Secret management with Key Protect

[Key Protect](https://www.ibm.com/cloud/key-protect){: target=_blank} is a tool that provides centralized management of encryption keys and sensitive information. Key Protect manages two different types of keys: `root keys` and `standard keys`.

`Root keys` are used to encrypt information in other systems, like the etcd database of the cluster, or data in Object Storage, or a MongoDB database. The details of which are the subject for a different article.

`Standard keys` are used to store any kind of protected information. The Key Protect plugin reads the contents of a standard key, identified by a given key id, and stores the key value into a secret in the cluster.

## Getting the Key Protect instance id

1. Set the target resource group and region for the Key Protect instance.

    ```shell
    ibmcloud target -g {RESOURCE_GROUP} -r {REGION}
    ```
  
2. List the available resources and find the name of the Key Protect instance.

    ```shell
    ibmcloud resource service-instances
    ```

3. List the details for the Key Protect instance. The `Key Protect instance id` is listed as `GUID`.

    ```shell
    ibmcloud resource service-instance {INSTANCE_NAME} 
    ```

## Creating a standard key

1. Open the IBM Cloud console and navigate to the Key Protect service

2. Within Key Protect, select the **Manage Keys** tab

3. Press the `Add key` button to open the "Add a new key" dialog

4. Select the `Import your own key` radio button and `Standard key` from the drop down

5. Provide a descriptive name for the key and paste the base-64 encoded value of the key into the `Key material` field

    **Note:** A value can be encoded as base-64 from the terminal with the following command:

    ```shell
    echo -n "{VALUE}" | base64
    ```

    If you need to encode a larger value, create the value in a file and encode the entire contents of the file with:

    ```shell
    cat {file} | base64
    ```

6. Click **Import key** to create the key

7. Copy the value of the **ID**
