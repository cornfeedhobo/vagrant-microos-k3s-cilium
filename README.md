# vagrant-microos-k3s-cilium

## Usage

1) Initialize the vagrant environment

    ```bash
    make vagrant-init
    ```

1) Start the VMs

    ```bash
    make vagrant-up
    ```

1) Wait for the VMs to shut down after combustion finishes, then reload

    ```bash
    make vagrant-reload
    ```

1) Connect to the first host and install cilium

    ```bash
    make vagrant-ssh-a
    sudo bash .vagrant/cilium.sh
    ```

1) Wait for pods to be ready
