## 00 Setup Workspace.R


github_create_repo <- function(reponame) {
  curl -F 'login=rsaporta' -F 'token=API Token' https://github.com/api/v3/yaml/repos/create -F name=reponame
}

setProject(projName="create_package", create.if.not.exist=TRUE, 
    subl=TRUE)

pkg_names <- c("rsutils", "rsuaspath", "rsuaws", "rsubitly", "rsudb", "rsujesus", "rsunotify", "rsuorchard", "rsuplotting", "rsuscrubbers", "rsushiny", "rsutils", "rsuvydia", "rsuworkspace", "rsuxls")
pkg_names <- c("rsutils", "rsuaspath", "rsuaws", "rsubitly", "rsudb", "rsujesus", "rsunotify", "rsuorchard", "rsuplotting", "rsuscrubbers", "rsushiny", "rsutils", "rsuvydia", "rsuworkspace")

parent_f <- c("~/Development/rsutils_packages")

default <- as.path(parent_f, "default", "")

for (pkg in pkg_names) {
  folder <- as.path(parent_f, pkg)
  sprintf("mkdir %s; cp -R %s/ %1$s", folder, default) %>% system

  f.desc <- as.path(folder, "DESCRIPTION")
  desc <- readLines(f.desc)
  first_four_lines <- 
  c(
    paste("Package:", pkg),
    paste("Type: Package"),
    paste("Title: RS", topropper_keywords(removeText(x=pkg, pat="^rsu")), "utils"),
    paste("Version 0.2.0")
  )

  desc[1:4] <- first_four_lines

  cat(desc, sep="\n", file=f.desc)
}