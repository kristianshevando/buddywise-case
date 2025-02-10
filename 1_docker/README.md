# 📝 Todo Application (Dockerized)

This project is a full-stack TODO application using **FastAPI (backend)** and **React (frontend)**, fully containerized with **Docker & Docker Compose**.

---

## **🔧 Prerequisites**
Ensure you have the following installed:
- [Docker](https://www.docker.com/products/docker-desktop/)
- [Docker Compose](https://docs.docker.com/compose/install/)

---

## **🚀 Quick Start**
To build and run the application locally, follow these steps:

### **1️⃣ Build and start the containers**
```sh
docker-compose up --build -d
```
- `--build` ensures images are rebuilt.
- `-d` runs containers in the background.

### **2️⃣ Access the application**
- **Frontend (React) →** `http://localhost`
- **Backend (FastAPI) →** `http://localhost:8000`
- **API Docs (Swagger UI) →** `http://localhost:8000/docs`

---

## **🛑 Stopping the application**
To stop and remove the containers, run:
```sh
docker-compose down
```

---

## **⚙️ Useful Commands**
| Command | Description |
|---------|-------------|
| `docker-compose up --build -d` | Build and start the application in detached mode |
| `docker-compose down` | Stop and remove all containers |
| `docker ps` | List running containers |
| `docker logs backend` | View backend logs |
| `docker logs frontend` | View frontend logs |

---

## **🐞 Troubleshooting**
### **1️⃣ Cannot access `http://localhost`**
- Ensure all containers are running:
  ```sh
  docker ps
  ```
- If not, restart them:
  ```sh
  docker-compose up --build -d
  ```

### **2️⃣ Backend is unreachable**
- Check logs:
  ```sh
  docker logs backend
  ```
- Ensure backend is running:
  ```sh
  curl http://localhost:8000/docs
  ```

### **3️⃣ Frontend is not loading**
- Try rebuilding everything:
  ```sh
  docker-compose down
  docker-compose up --build -d
  ```