from splinter import Browser
from bs4 import BeautifulSoup
import pandas as pd
import datetime as dt


def scrape_all():

    # setup chromedriver
    browser = Browser("chrome", executable_path="chromedriver", headless=True)
    news_title, news_paragraph = mars_news(browser)

    # scrape and create data
    data = {
        "news_title": news_title,
        "news_paragraph": news_paragraph,
        "featured_image": featured_image(browser),
        "hemispheres": hemispheres(browser),
        "weather": twitter_weather(browser),
        "facts": mars_facts(),
        "last_modified": dt.datetime.now()
    }

    # stop chromedriver and return data
    browser.quit()
    return data


def mars_news(browser):
    url = "https://mars.nasa.gov/news/"
    browser.visit(url)

    # Get first list item and use delay
    browser.is_element_present_by_css("ul.item_list li.slide", wait_time=0.5)

    html = browser.html
    news_soup = BeautifulSoup(html, "html.parser")

    try:
        slide_elem = news_soup.select_one("ul.item_list li.slide")
        news_title = slide_elem.find("div", class_="content_title").get_text()
        news_para = slide_elem.find(
            "div", class_="article_teaser_body").get_text()

    except AttributeError:
        return None, None

    return news_title, news_para


def featured_image(browser):
    url = "https://www.jpl.nasa.gov/spaceimages/?search=&category=Mars"
    browser.visit(url)

    # find full image element and use click function
    full_image_elem = browser.find_by_id("full_image")
    full_image_elem.click()

   # find more info element and use click
    browser.is_element_present_by_text("more info", wait_time=0.5)
    more_info_elem = browser.find_link_by_partial_text("more info")
    more_info_elem.click()

    # parse HTML with beautiful soup
    html = browser.html
    img_soup = BeautifulSoup(html, "html.parser")

    # find the relative image url
    img = img_soup.select_one("figure.lede a img")

    try:
        img_url_rel = img.get("src")

    except AttributeError:

        return None

   # create img_url
    img_url = f"https://www.jpl.nasa.gov{img_url_rel}"

    return img_url


def hemispheres(browser):

    # mars astrogeology url
    url = (
        "https://astrogeology.usgs.gov/search/"
        "results?q=hemisphere+enhanced&k1=target&v1=Mars"
    )

    browser.visit(url)

    # loop through links, click link, find sample anchor, return the href
    hemisphere_image_urls = []
    for i in range(4):

        # find the elements on each loop
        browser.find_by_css("a.product-item h3")[i].click()

        hemi_data = scrape_hemisphere(browser.html)

        # append hemisphere object to list
        hemisphere_image_urls.append(hemi_data)

        # navigate back
        browser.back()

    return hemisphere_image_urls

# Mars facts
def twitter_weather(browser):
    url = "https://twitter.com/marswxreport?lang=en"
    browser.visit(url)

    html = browser.html
    weather_soup = BeautifulSoup(html, "html.parser")

    # find a tweet with Mars Weather
    tweet_attrs = {"class": "tweet", "data-name": "Mars Weather"}
    mars_weather_tweet = weather_soup.find("div", attrs=tweet_attrs)

    # search for p tag containing the tweet text
    mars_weather = mars_weather_tweet.find("p", "tweet-text").get_text()

    return mars_weather


def scrape_hemisphere(html_text):

    # beautiful soup using html parse
    hemi_soup = BeautifulSoup(html_text, "html.parser")

    # get href and text except if error.
    try:
        title_element = hemi_soup.find("h2", class_="title").get_text()
        sample_element = hemi_soup.find("a", text="Sample").get("href")

    except AttributeError:

        # image error returns None
        title_element = None
        sample_element = None

    hemisphere = {
        "title": title_element,
        "img_url": sample_element
    }

    return hemisphere


def mars_facts():
    try:
        df = pd.read_html("http://space-facts.com/mars/")[0]
    except BaseException:
        return None

    df.columns = ["description", "value"]
    df.set_index("description", inplace=True)

    # striped table
    return df.to_html(classes="table table-striped")


if __name__ == "__main__":

    # print scraped data
    print(scrape_all())
