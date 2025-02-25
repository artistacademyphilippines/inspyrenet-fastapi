# Use the official Python 3.13.2 slim image
FROM python:3.13.2-slim

# Install system dependencies (including libgl1 and additional libraries)
RUN apt-get update && \
    apt-get install -y \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    ffmpeg && \
    rm -rf /var/lib/apt/lists/*

# Create and set the working directory to /docker inside the container
WORKDIR /docker

# Copy the requirements.txt file into the /docker directory inside the container
COPY requirements.txt /docker/

# Create a virtual environment in the container
RUN python -m venv /venv

# Activate the virtual environment and upgrade pip inside the virtual environment
RUN /venv/bin/pip install --upgrade pip

# Install Python dependencies within the virtual environment
RUN /venv/bin/pip install --no-cache-dir -r /docker/requirements.txt

# Copy the application code (api folder) into the /docker/api directory inside the container
COPY api /docker/api

# Expose port 8080 for FastAPI to run
EXPOSE 8080

# Command to run FastAPI app on port 8080 using the virtual environment
CMD ["/venv/bin/uvicorn", "docker.api.app:app", "--host", "0.0.0.0", "--port", "8080"]
