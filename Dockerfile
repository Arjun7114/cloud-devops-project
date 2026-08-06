# A Dockerfile is a recipe. Docker reads it top-to-bottom to build your image.

# 1. Start FROM a base image that already has Python 3.11 installed.
#    "slim" means a smaller, lighter version — good practice.
FROM python:3.11-slim

# 2. Set the working folder INSIDE the box. Everything after this
#    happens in /app inside the container.
WORKDIR /app

# 3. Copy the requirements file in first, then install dependencies.
#    (We copy this before the rest of the code on purpose — it makes
#     future rebuilds faster. Docker caches this step.)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 4. Copy the rest of your app code into the box.
COPY . .

# 5. Tell Docker the app uses port 5000 (documentation for humans/tools).
EXPOSE 5000

# 6. The command that runs when the container starts: launch the app.
CMD ["python", "app.py"]
