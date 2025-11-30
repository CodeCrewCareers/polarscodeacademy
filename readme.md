# Polars Code Academy 

Welcome to the official Polars Code Academy Repo. You can find Jupyter notebooks and datasets used in our tutorials. 

## Getting Started

### 1. Cloning the Repo

We recommend you clone the entire repo. Doing so will make it so that all jupyter notebooks will run successfully. 

```
git clone https://github.com/CodeCrewCareers/polarscodeacademy.git
```

### 2. Quick Virtual Environment Setup

To start running the notebooks right away, we recommend you create a virtual environment using uv. Should take less than 5 seconds with the following commands:

```cmd
uv venv
uv pip install -r requirements.txt
```



## Docker Containers

We started using docker containers to give learners the ability to quickly spin up databases used in our videos. These  containers require a slightly more technical setup, but they provide great real life practice. 

Create Container
```ps1
docker compose up -d
```
Check that it's Running
```ps1
docker ps
```
