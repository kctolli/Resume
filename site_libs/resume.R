source("https://raw.githubusercontent.com/kctolli/scripting/main/Rscript/include.R")

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
  ### Create a temp html file
  tmp_html <- fs::file_temp(ext = ".html") 
  
  ### Knit the HTML version
  rmarkdown::render("index.rmd", params = list(pdf_mode = FALSE), output_file = "index.html")
  
  ### Knit the PDF version to temporary html location
  rmarkdown::render("index.rmd", params = list(pdf_mode = TRUE), output_file = tmp_html)
  
  ### Convert to PDF using Pagedown
  pagedown::chrome_print(input = tmp_html, output = glue::glue("resume.pdf"))
  
  ### Delete temp html file
  file.remove(tmp_html) 
  
  ### Convert index.md to README.md
  file.rename("index.md", "README.md") 
  file.exists("index.md")
  file.exists("README.md")
}