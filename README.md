pull-request-roulette
=====================

[![Code Climate](https://codeclimate.com/github/davearonson/pull-request-roulette.png)](https://codeclimate.com/github/davearonson/pull-request-roulette)
[![Build Status](https://travis-ci.org/davearonson/pull-request-roulette.png)](https://travis-ci.org/davearonson/pull-request-roulette)
[![Coverage Status](https://coveralls.io/repos/davearonson/pull-request-roulette/badge.png?branch=master)](https://coveralls.io/r/davearonson/pull-request-roulette?branch=master)
[![Dependency Status](https://gemnasium.com/davearonson/pull-request-roulette.svg)](https://gemnasium.com/davearonson/pull-request-roulette)
[![PullReview stats](https://www.pullreview.com/github/davearonson/pull-request-roulette/badges/master.svg?)](https://www.pullreview.com/github/davearonson/pull-request-roulette/reviews/master)

Web app to match up developers, with public pull requests (PRs) on Github, with
people willing to comment on their PRs.

The current workflow is:

- Project owner Polly has a project.

- Coder Carol submits a pull request to Polly's project.

- Either Carol or Polly (or currently, anybody!) submits Carol's PR to Pull
  Request Roulette (PRR).  Most likely, she'll have done that because Polly
  just hasn't had the time to look at the PR and approve it.

- Reviewer Rachel comes to PRR, sees Carol's PR in the list, and "takes" it.

- It is now marked as under review by Rachel.

- The hope is that Rachel will give Carol's PR a thorough review, using
  comments or email to notify Carol and Polly when done, and Rachel's comments
  will help Polly decide whether to accept it.

- The next step is that Carol or Rachel or Polly will come to PRR and mark the
  PR as no longer under review, either to solicit more reviews, or to remove it
  from the list.  However, that step is not yet implemented.

Yes, that's very simple.  There's only one thing being stored (a simple PR
descriptor), and it's not even full CRUD as there is no Update.  But this is
just the MVP.  The main workflow I envision eventually is:

- Project owner Polly has a project.

- Coder Carol submits a pull request to Polly's project.

- Either Carol or Polly (or *maybe* anybody) submits Carol's PR to PRR.

- PRR looks at what languages the files in the PR use, and lets the submitter
  adjust the list.  (This may be needed due to .txt files, or files with no
  extension, being in some human language, so that for instance the reviewer
  needs to know Chinese.  Other than that, it means computer languages.  It
  might deduce some human languages from filenames like fr.yml.  I do not
  intend for it to grow language-detection from text, a la Google Translate.)

- Reviewer Rachel has registered at PRR, and possibly specified what languages
  she knows.

- Rachel comes to PRR, and asks for a PR to review.

- PRR analyzes the possible matches, decides that Carol's is the best match,
  and presents it (and no others) to her.  This is the "roulette" aspect I'm
  aiming for.

- That includes the details of how many files in what languages, how many
  additions, deletions, and other changes, etc.

- Rachel may decline it and ask for a different one, but in this case let's say
  she accepts, or in current parlance, "takes" it.

- PRR marks it as being assigned to Rachel for review.

- PRR notifies Carol and Polly... *if* it has their email addresses.

- Polly sees the email and thinks "hmmm, what is this PRR thing and how does it
  have my email address?"  (The answer is, either Polly signed up on PRR after
  we established user profiles, or she made it public on Github.)

- Meanwhile, Reviewer Roger comes to PRR and asks for a PR to review.

- PRR determines that Carol's *would* be the best match for him, *except* that
  it's already being reviewed, so it looks for the second best.

- Rachel makes comments on Github, mainly in the PR but possibly in the
  project's issues.  Github notifies Carol, Polly, and any other interested
  parties; PRR is not involved.

- Rachel comes back to PRR, and marks the PRR as reviewed.

- PRR notifies Carol and Polly... *if* it has their email addresses.

- PRR asks Rachel to rate Carol as a coder.

- Carol comes back to PRR, and rates Rachel as a reviewer.

- Brief aggregate ratings as coder and/or reviewer are shown when someone lists
  the users (at least, those who don't hide their profiles); more detailed
  ratings, if we decide to have them, are shown when someone views their
  profiles.

- Top coders and/or reviewers may be featured on the front page, newsletter,
  etc.

If Rachel shirks her duty, then the fact that the PR has been "taken" will
count for less and less, when PRR decides on matches.  Eventually, either the
PR could be marked as "untaken", or it could be under review by multiple
reviewers at once.  There could be a "pestering" mechanism so that Rachel gets
reminded every few days... again, *if* we have her email address.  We could
require it, but I don't like that idea.

See the Issues for possible features saved for later, known bugs to fix, etc.

The code is currently deployed at http://www.PullRequestRoulette.com, as a free
public service of [Codosaurus, LLC](http://www.Codosaur.us).
