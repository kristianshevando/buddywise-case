def test_update_task(client):
    task = client.post("/tasks", json={"title": "Task to update"}).json()
    task_id = task["id"]

    update_response = client.put(f"/task/{task_id}", json={"id": task_id, "title": "Updated Task", "status": True})
    assert update_response.status_code == 200
    assert update_response.json()["title"] == "Updated Task"

def test_delete_task(client):
    task = client.post("/tasks", json={"title": "Task to delete"}).json()
    task_id = task["id"]

    delete_response = client.delete(f"/task/{task_id}")
    assert delete_response.status_code == 200
