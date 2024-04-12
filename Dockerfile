# Utiliser une image Alpine pour un environnement léger
FROM python:3.10-alpine

# Mettre à jour et installer les dépendances nécessaires
RUN apk add --no-cache bash

# Ajouter les fichiers de dépendances Python et installer les packages
COPY ./webapp/requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Copier le code de l'application dans le conteneur
COPY ./webapp /opt/webapp/
WORKDIR /opt/webapp

# Créer un utilisateur non-root pour exécuter l'application
RUN adduser -D myuser
USER myuser

# Définir la commande pour démarrer l'application
# Utiliser une variable d'environnement PORT qui peut être configurée par la plateforme (Heroku, Render, etc.)
CMD ["sh", "-c", "gunicorn --bind 0.0.0.0:$PORT wsgi"]
