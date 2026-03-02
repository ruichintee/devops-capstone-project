# Use a small base image to keep the footprint low
FROM python:3.9-slim

# Create working folder and install dependencies
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application contents
COPY service/ ./service/

# Switch to a non-root user for security (Principle of Least Privilege)
RUN useradd --uid 1000 theia && chown -R theia /app
USER theia

# Run the service on port 8080 using Gunicorn
EXPOSE 8080
CMD ["gunicorn", "--bind=0.0.0.0:8080", "--log-level=info", "service:app"]