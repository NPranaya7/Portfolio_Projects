from langchain.llms import OpenAI
from langchain.prompts import PromptTemplate
from langchain.chains import LLMChain
from langchain.chains import SequentialChain
from openai_s_key import openapi_key

import os 

os.environ['OPENAI_API_KEY'] = openapi_key

llm = OpenAI(temperature = 0.7)


def generate_resturant_name_and_items(cuisine):
    # Chain 1: Resturant Name
    prompt_template_name = PromptTemplate(
        input_variables=['cuisine'],
        template="I want to open a resturant for {cuisine} food. suggest a fancy name for this."
    )
    
    name_chain = LLMChain(llm = llm, prompt = prompt_template_name, output_key = 'restaurant_name')
    
    # Chain 2 Menu Items
    prompt_template_items = PromptTemplate(
        input_variables=['restaurant_name'],
        template="""Suggest some menu items for {restaurant_name}. return it as a comma separated string"""
    )
    
    food_items_chain = LLMChain(llm = llm, prompt = prompt_template_items, output_key = 'menu_items')
    
    chain = SequentialChain(
        chains = [name_chain, food_items_chain],
        input_variables = ['cuisine'],
        output_variables = ['restaurant_name', 'menu_items']
    )
    
    response = chain({'cuisine': cuisine})
    
    return response
