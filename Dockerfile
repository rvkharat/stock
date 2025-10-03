# Use a stable Python base with wheels available for common packages
FROM python:3.10-slim

# Working directory
WORKDIR /app

# Install system dependencies required for some Python packages to build/run
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    g++ \
    libatlas-base-dev \
    libblas-dev \
    liblapack-dev \
    libffi-dev \
    libssl-dev \
    git \
    curl \
 && rm -rf /var/lib/apt/lists/*

# Copy requirements first to leverage Docker cache
COPY requirements.txt /app/requirements.txt

# Upgrade pip and install dependencies
RUN python -m pip install --upgrade pip setuptools wheel
RUN pip install --no-cache-dir -r /app/requirements.txt

# Copy application code
COPY . /app

# Expose port (Render provides $PORT at runtime)
EXPOSE 8501

# Start Streamlit using PORT provided by Render
CMD ["sh", "-c", "streamlit run app.py --server.port $PORT --server.headless true --server.enableCORS false"]
