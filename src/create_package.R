## 00 Setup Workspace.R

get_github_token <- function(...) {
  "rsaporta"
}

get_github_token <- function(...) {
  ""
}


github_create_repo <- function(reponame, username=get_github_token(), api_token=get_github_token(),  description="", private=TRUE, auto_init=FALSE, license_template=NULL, verbose=TRUE) {
## REFERENCE: https://developer.github.com/v3/repos/

  params <- list(name=reponame, description=description, private=private, auto_init=auto_init, license_template=license_template)
  params.json <- jsonlite::toJSON(params, auto_unbox=TRUE)

  if (verbose)
    cat("Creating repo '", reponame, "' ... ", sep="")

  cmd <- "curl -u \"%s:%s\" https://api.github.com/user/repos -d '%s'" %>%
            sprintf(username, api_token, params.json)

  responseJSON <- system(cmd, intern=TRUE)

  responseList <- jsonlite::fromJSON(responseJSON)
  html_url <- responseList [["html_url"]]
  if (!is.null(html_url) && verbose)
    cat("succesfully created at '", html_url, "'\n", sep="")
  if (is.null(html_url))
    warning("Repo creation may have failed for '", reponame, "' --  cmd was:\n  ", cmd)
  ## TODO: Check for "Validation Failed" response

  return(responseList)
}



setProject(projName="create_package", create.if.not.exist=TRUE, 
    subl=TRUE)

## SETUP
pkg_names <- c("rsutils2", "rsuaspath", "rsuaws", "rsubitly", "rsudb", "rsujesus", "rsunotify", "rsuorchard", "rsuplotting", "rsuscrubbers", "rsushiny", "rsuvydia", "rsuworkspace", "rsuxls", "rsucurl", "rsudict")
parent_f <- c("~/Development/rsutils_packages")
default <- as.path(parent_f, "default", "")

## STEP ONE, CREATE THE FOLDERS
for (pkg in pkg_names) {
  catn("Creating folder for pkg '", pkg, "'", sep="")

  folder <- as.path(parent_f, pkg)
  sprintf("mkdir %s; cp -R %s/ %1$s", folder, default) %>% system
  file.rename(from=as.path(folder, "rsutils.Rproj"), to=as.path(folder, pkg, ext=".Rproj"))

  f.desc <- as.path(folder, "DESCRIPTION")
  desc <- readLines(f.desc)
  first_four_lines <- 
  c(
    paste("Package:", pkg),
    paste("Type: Package"),
    paste("Title: RS", topropper_keywords(removeText(x=pkg, pat="^rsu")), "utils"),
    paste("Version: 0.2.0")
  )

  desc[1:4] <- first_four_lines

  cat(desc, sep="\n", file=f.desc)

}

## STEP ONE, CREATE THE FOLDERS
for (pkg in pkg_names) {
  catn("Editing pkg '", pkg, "'", sep="")
  folder <- as.path(parent_f, pkg)

  if (pkg != "rsutils2") {
    files_in_folder <- dir(paste0(folder, "/R"), full=TRUE)
    new_file_names <- gsub(pat=paste0("/R/", removeText("rsu", pkg), "__"), "/R/", x=files_in_folder)
    file.rename(from=files_in_folder, to=new_file_names)
  }
}

## NEXT STEP
MANUALLY remove files not needed from each folder

## STEP THREE THE REPO


for (pkg in pkg_names) {  
  ## try to create the repo
  repo.response <- github_create_repo(reponame=pkg, description=pasteC(first_four_lines, C=" <BR> "), private=TRUE, auto_init=FALSE, verbose=TRUE)

  repo.url <- repo.response[["html_url"]]

  setwd(folder)

  devtools::build(path=folder)

  # system("git init")
  # system("git add *")
  # system("git add .gitignore")
  # system("git add .Rbuildignore")
  # system("git status")

  # system("git commit -m \"initial commit\"")
  # system(sprintf("git remote add origin git@github.com:rsaporta/%s.git", pkg))
  # system("git push --set-upstream origin master")
}

TODO
R CMD and build the packages













