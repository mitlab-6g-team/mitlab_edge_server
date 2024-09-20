- # MITLAB-AI/ML-Edge Server
  The project is for the 6G NSTC(also called MOST). In the project, we offer automatic AI model training and deployment on the AI/ML platform we design.
- ## Goal

  The goal of the project is to build a control panel on ORAN RIC to control the automatic model training or deployment on the xApp/rApp.

- ## How to run the project ?

  - ### Step 1. Setting .env

    ```bash=
    # Path : mitlab_edge_server/

    # Backend env setting
    cp .env.common.sample .env.common

    Change required: User configuration in install_all.sh
    !!! Please ensure that DEPLOYMENT_PLATFORM_IP and HARBOR_IP are filled !!!
    ```

  - ### Step 2. Run Shell

    ```bash=
    # Path : mitlab_edge_server/

    bash ./install_all.sh
    ```