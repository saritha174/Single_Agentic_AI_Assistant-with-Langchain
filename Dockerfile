# 1. Start from a small Linux image that already has Python 3.11
FROM python:3.11-slim

# 2. Settings: no .pyc files, print logs immediately
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# 3. The working folder inside the container
WORKDIR /app

# 4. Install libraries first (Docker caches this step = faster rebuilds)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copy the rest of your code into the container
COPY . .

# 6. Don't run as admin (security best practice)
RUN useradd -m appuser
USER appuser

# 7. Document the port Streamlit uses
EXPOSE 8501

# 8. Start the app. Render gives the port in $PORT; locally it defaults to 8501
CMD streamlit run app.py --server.port=${PORT:-8501} --server.address=0.0.0.0 --server.headless=true
