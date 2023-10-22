# CONTRIBUTING

Something is not clear or incorrenct or incomplete, something needs some updates over time or you found something new and cool that absolutely needs to be shared with the others... please contribute to this docs!!!

## Submit an issue (no git/github skills required)

Open an issue from [here](https://github.com/cpp-lln-lab/CPP_HPC/issues/new/choose) and try to be the most detailed possible.

## Make the changes your self (minor git/github skills required)

The actual text/scripts you find in this website are in this [repo](https://github.com/cpp-lln-lab/CPP_HPC) and in the `doc` folder [here](https://github.com/cpp-lln-lab/CPP_HPC/tree/main/doc)

Each article/section of the website is a specific markdown file with the same transparent name (more or less).

### Edit from github

Just find the the markdown file you want to edit (eg the one for this section [contributing.md](https://github.com/cpp-lln-lab/CPP_HPC/blob/main/doc/contributing.md)) and click on `edit` (the pen icon) on the top right.

When done, click on `commit changes` (green botton on the top right) and select `Create a new branch for this commit and start a pull request` and then `Commit changes`.

On the new opened page you can edit the title of the pull request to provide a more meaningful one, select a reviewer (highly reccomended!!!) and then finally create the pull request (PR).

If you fill confident you can then merge it right away or ask someone else to review the PR and then approve it with or without corrections and merge it.

To change the website strucute (change name to section, add sections or reorder them), see the file `mkdocs.yml` section `Pages`.

That's it!

### Edit locally

1. fork this repository
2. clone your forked repository
3. install the dependencies via:

```bash
pip install -r requirements.txt
```

4. create a branch
5. make your changes in the respective markdown file in the `doc` folder
6. visualize your changes by deploying a website preview via:

```bash
mkdocs serve
```

and view the preview here [http://127.0.0.1:8000/welcome](http://127.0.0.1:8000/welcome)

7. push your changes to your forked repository
8. open a pull request
