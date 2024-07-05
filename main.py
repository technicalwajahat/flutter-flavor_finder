import re

import pandas as pd
from flask import Flask, request, render_template
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity

app = Flask(__name__)

# Load the dataset
file_path = 'weather_recipes.csv'
recipes_df = pd.read_csv(file_path)

# Manually define a set of stop words
stop_words = {'a', 'an', 'the', 'and', 'or', 'in', 'of', 'to', 'with', 'on', 'for', 'at', 'by', 'from', 'up', 'down',
              'but', 'is', 'are', 'was', 'were', 'be', 'been', 'being', 'has', 'have', 'had', 'do', 'does', 'did',
              'will', 'would', 'shall', 'should', 'can', 'could', 'may', 'might', 'must', 'that', 'this', 'these',
              'those', 'it', 'its', 'he', 'she', 'they', 'them', 'his', 'her', 'their', 'there'}


# Function to preprocess the text
def preprocess_text_without_nltk(text):
    text = text.lower()
    text = re.sub(r'[^a-z\s]', '', text)
    tokens = text.split()
    tokens = [word for word in tokens if word not in stop_words]
    return ' '.join(tokens)


# Apply preprocessing to the ingredients column if not already present
if 'ingredients_cleaned' not in recipes_df.columns:
    recipes_df['ingredients_cleaned'] = recipes_df['ingredients'].apply(preprocess_text_without_nltk)

# Vectorize the cleaned ingredients using TF-IDF
tfidf_vectorizer = TfidfVectorizer()
tfidf_matrix = tfidf_vectorizer.fit_transform(recipes_df['ingredients_cleaned'])


# Function to recommend recipes based on input ingredients
def recommend_recipes_by_ingredients(input_ingredients, n_recommendations=10):
    input_ingredients_cleaned = preprocess_text_without_nltk(input_ingredients)
    input_vec = tfidf_vectorizer.transform([input_ingredients_cleaned])
    cosine_similarities = cosine_similarity(input_vec, tfidf_matrix).flatten()
    similar_indices = cosine_similarities.argsort()[-n_recommendations:][::-1]
    recommended_recipes = recipes_df.iloc[similar_indices]
    return recommended_recipes


# Function to recommend recipes based on weather condition
def recommend_recipes_by_weather(weather_condition, n_recommendations=10):
    filtered_recipes = recipes_df[recipes_df['weather_condition'] == weather_condition]
    if len(filtered_recipes) < n_recommendations:
        return filtered_recipes
    recommended_recipes = filtered_recipes.sample(n=n_recommendations)
    return recommended_recipes


@app.route('/')
def home():
    return render_template('index.html')


@app.route('/recommend_by_ingredients', methods=['POST'])
def recommend_by_ingredients():
    data = request.form
    input_ingredients = data.get('ingredients', '')
    recommendations = recommend_recipes_by_ingredients(input_ingredients)
    recommendations = recommendations.fillna("N/A")
    recommended_recipes_list = recommendations.to_dict(orient='records')
    return recommended_recipes_list

    # return render_template('recommendations.html', recommendations=recommendations.to_dict(orient='records'),
    #                        section='ingredients')


@app.route('/recommend_by_weather', methods=['POST'])
def recommend_by_weather():
    data = request.form
    weather_condition = data.get('weather', '')
    recommendations = recommend_recipes_by_weather(weather_condition)
    recommendations = recommendations.fillna("N/A")
    recommended_recipes_list = recommendations.to_dict(orient='records')
    return recommended_recipes_list

    # return render_template('recommendations.html', recommendations=recommendations.to_dict(orient='records'),
    #                        section='weather')


@app.route('/recipe_details/<recipe_name>/<section>')
def recipe_details(recipe_name, section):
    recipe_detail = recipes_df[recipes_df['recipe_name'] == recipe_name].iloc[0]
    return render_template('recipe_details.html', recipe_details=recipe_detail, section=section)


if __name__ == '__main__':
    app.run(debug=True, host="0.0.0.0", port=8005)
