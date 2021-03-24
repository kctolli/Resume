source("https://raw.githubusercontent.com/kctolli/scripting/main/Rscript/js.R")
source("https://raw.githubusercontent.com/kctolli/scripting/main/Rscript/css.R")
source("https://raw.githubusercontent.com/kctolli/scripting/main/Rscript/html.R")
source("https://raw.githubusercontent.com/kctolli/scripting/main/Rscript/gsheets.R")
source("https://raw.githubusercontent.com/kctolli/scripting/main/Rscript/copyright.R")
source("https://raw.githubusercontent.com/kctolli/scripting/main/Rscript/templates.R")

# Variables / Basic Functions

here <- here::here() ## set here file path

load_libraries <- function(){
  pacman::p_load(tidyverse, pacman, glue, pander, lubridate, knitr, rmarkdown) ## Load Packages
  opts_chunk$set(results = 'asis', echo = FALSE, message = FALSE, warning = FALSE) ## Chunk Displays
}

# Section Templates

print_resume_section <- function(section_id){
  
  cv <- entries %>% filter(in_resume) ## entries in resume
  
  glue_template <- "
### {title}

{institution}

N/A

{end}

- {description_1}
- {description_2}
- {description_3}
\n\n\n"
  
  section(cv, section_id, glue_template)
}

print_section_resume<- function(section_id){
  
  cv <- entries %>% filter(in_resume) ## entries in resume
  
  glue_template <- "
### {title}

{institution}

N/A

{start} <br> | <br> {end}

- {description_1}
- {description_2}
- {description_3}
\n\n\n"
  
  section(cv, section_id, glue_template)
}

# Render

## Knit the Resume to html and pdf
render_resume <- function(){
  tmp_html <- fs::file_temp(ext = ".html") ### Create a temp html file
  
  ### Knit the HTML version
  rmarkdown::render("index.rmd", params = list(pdf_mode = FALSE), output_file = "index.html")
  
  ### Knit the PDF version to temporary html location
  rmarkdown::render("index.rmd", params = list(pdf_mode = TRUE), output_file = tmp_html)
  
  ### Convert to PDF using Pagedown
  pagedown::chrome_print(input = tmp_html, output = glue::glue("resume.pdf"))
  
  file.remove(tmp_html) ### Delete temp html file
  
  ### Convert index.md to README.md
  file.rename("index.md", "README.md") 
  file.exists("README.md")
}