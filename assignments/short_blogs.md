# Short Form Blogs 

# Blog 1: Motivating a Point 

As we have discussed, data visualization is often useful for motivating a point. Particularly, data visualization can be a succinct way of showing people why some question of scientific or journalistic inquiry matters. 

This short form blog will address some *political* question in which you might be interested. As we talked about, political data does not always have to be about *politics*, nor does it have to be a topic addressed in mainstream political science. So, you can absolutely think broadly about the politics in your own lives or the politics that influence your own interests. I will provide a list of potential datasets that will be useful, but if you have any data source in mind already or have questions about what constitutes a good political or social question, please consult with me. 

You should write as if you are pitching something to a popular outlet. Imagine you want to write an exposé or some long-form journalism story for a major outlet, but you need to provide some documentation that what you want to write about is indeed worth the time. Therefore, this should not be written as an academic report, nor should it be written as some sensationalized rant about the point you want to make. Rather, you should write a succinct, honest memo of about 1,200 to 1,500 words plus 4 original visualizations to show that data out there confirms the importance and validity of your question (and potential hypothesis/solution) for a wide audience. I will not be *incredibly keen or critical* of minor grammar issues, so long a you provide a thoughtful and interesting commentary between your question and the data.  

Use the word count wisely! Begin the memo by conveying the problem that you are interested in, including some news relevant information (~250). You should expect to write a bit about the source of your data and why it's trustworthy, as well as any limitations (~150-200 words). The remainder of the text should address the question you are posing and how the data illustrates the importance of the question (~800-1,000). Talk about how you used the data, how we should interpret the visualizations and the measurements used, and any limitations of the visualizations you chose (e.g. if you had the opportunity to gather more data, what would you get?). Nest your visualizations within the text so the body flows like a typical blog post. 

You do not need to make extensive reference to political science academic work unless it is actually relevant. You should provide hyperlinked citations on your personal blog, as well as a bibliography at the end of the text. Remember to provide a citation for your dataset and any additional R packages that you use. Additionally, you should incorporate alt-text to accompany your visualizations. This is easy to do in Github or Markdown formats, [check out this link.](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax) 

## Grading Criteria: 

1) The blog identifies an interesting political question and identifies a relevant data source to explore the question (+3)

2) The blog includes 4 + original visualizations that are meaningful toward the question posed by the author. (+7.5)

3) The author makes a reasonable effort to identify the limitations of the data and their visualizations toward the exploration of the question at hand. (+3)

4) The blog adopts the proper tone identified in the assignment description (+1.5)

---

# Blog 2: Many ways to see it 

Here you will explore the relationship between two variables housed in the V-Dem dataset. As we talked about in class, this dataset is available when you install and load in the package `vdemdata` in R. You'll specifically want to look at the dataset called `vdem` If you'd like some help to access this package, the [GitHub repo for the package and dataset](https://github.com/vdeminstitute/vdemdata) are probably the best place to start. The codebook for this dataset is [here](https://www.v-dem.net/static/website/img/refs/codebookv111.pdf). 

For this short form blog **I'd like you to look at just TWO variables and their relationship.** You may also include **contextual variables** such as country, region, and year; however, other substantive variables should be avoided. You will explore the nature of the relationship between these two variables (and potential variation over contextual variables), over **4 different visualizations.** This means that you should produce four different specifications of how to look at the variables together, and potentially their association across time and space. **You must use at least three different `geom_` functions** in this blog, to mean you can't just turn in 4 variations of a line or bar graph. A portion of the grade on these visualizations will be determined **based on your ability to make these visualizations "yours",** in the sense that you are continuing to explore the types of themes and aesthetic details that you feel embody design by YOU.  

Because V-Dem gather their data via expert surveys, they use measurement models to aggregate these measures over distinct sources. Therefore, the direct variable that you choose to work with might be a bit confusing to interpret relative to the original scale that was used to measure it. For this reason, you may also opt to use the variable name with `_osp` appended to it, so that you can translate your results via the original measurement scale. If you would prefer to defer to the primary variable with the changed measurement and would like to discuss what this means for interpretation, feel free to talk with me. 

Regarding the textual part of this assignment, you should plan to write a max of about 500 words. If you use less in a meaningful way that is fine, so long as you achieve the following:

Use your wordspace to **describe the variables** that you are looking at, including how they were measured and any way that you might have changed the measurement along the way. The remainder of your text should be used to put into words **how you would describe the relationship and potential implications for the type of relationship that exists** between your choice of variables. These do not have to be academic observations necessarily, but something that might interesting to explore down the line based on the relationship you find. Furthermore, you might choose to subset these variables based on a tim period, country or region, or group of countries that we might group together in some way (example, the G20). If you do so, please try to **characterize this choice and what leverage we might gain from looking at just these observations.**

If you have any news or academic sources please cite them in text, via a hyperlink. To cite the packages that you use to develop the blog, please consult the folder in the GitHub repo for the class titled "bib-example" where you can see how to develop a quick bibliography of all the packages that we are now using. *Append your bibliography in some way to your entire site OR include at the end of your text.* We will go over this in class on Tuesday, Nov. 8 for clarity. 

## Grading Criteria: 

1) The blog includes 4+ visualizations that implement at least 3 different geom functions to produce them. (+8)

2) The author makes reasonable effort to provide accurate descriptions of the relationship between the variables that they are exploring.  (+3)

3) The author has used visual and aesthetic elements apart from default ggplot design. The author has manipulated some of the following elements to explore the features that they like to bring out in design: text, colors, background, whitespace. 

4) The blog cites the packages used and includes relevant hyperlinks to other sources, as appropriate (+1). 


 



