import streamlit as st
import langchain_helper

st.title("Resturant Name & Menu Generator")

cuisine = st.sidebar.selectbox('Pick a cuisine', ("Indian", "Mexican", "Greek", "Japanise", "American", "Meditarian", "Italian"))

# st.sidebar.chat_input('Cuisine Type')



if cuisine:
    response = langchain_helper.generate_resturant_name_and_items(cuisine)
    st.header(response['restaurant_name'].strip())
    menu_items = response['menu_items'].strip().split(",")
    st.subheader("**Menu**")
    for item in menu_items:
        st.write(item)