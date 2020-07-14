v0.0.0
This is the initial commit

The structure of the app will be as follows:

MASTER branch
* Each commit should be a release version. This follows Semantic Versioning, so MAJOR.MINOR.PATCH numbering

DEVELOPMENT branch
* This is branched off of MASTER, and where all of the features should be branched off of and pushed to

RELEASE branches
* Once ready, a release will be branched from DEVELOPMENT and merged to both DEVELOPMENT and MASTER following the versioning convention

FEATURE branches
* Each story in the Jira project should be a separate branch with the appropriate code. Do this in Jira and checkout the branch.

HOTFIX branches
* These should be branched off MASTER and pushed to both MASTER and DEVELOPMENT, and should only be for quickly patching things. Again, follow the versioning convention.