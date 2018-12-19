# Background 

This project addresses a gap in the current Sonarqube (Community Edition) distribution model. While Enterprise Linux is a supported platform, no official RPM downloads are avialable. Previously, the Sonarqube project pointed RPM-seeking users to their semi-blessed "unofficial" RPMs. However, the maintainer of _that_ service discontinued his efforts. These tools are meant to address the current RPM-gap.

# How to Contribute

It would be great if users of this project could help by identifying further gaps that our specific use-cases have not uncovered. In an ideal world, that help would come in the form of code-contributions (via pull-requests). Next-best option is submitting Issues identifying gaps with as great of detail as possible - preferably inclusive of suggestions for mitigating those gaps.

In the interest of full disclosure, the fruits of this automation-effort are openly provided on a wholly "as-is" basis. Individuals who have stumbled on this project and find deficiencies in it are invited to help us enhance the project for broader usability (as described above).

## Testing

It's expected that code-summissions are tested. We do not currently bundle any test-suites into this project (look: a gap you could fill!). Basically, if you update the tools and the tools still produce RPMs, you can probably consider that a valid test.

## Submitting Changes

In general, we prefer changes be offered in the form of tested pull-requests. Prior to opening a pull-request, we also prefer that an associated issue be opened - you can request that you be assigned or otherwise granted ownership in that issue. The submitted pull-request should reference the previously-opened issue. The pull-request should include a clear list of what changes are being offered (read more about [pull requests](http://help.github.com/pull-requests/)). 


Please ensure that commits included in the PR are performed with both clear and concise commit messages. One-line messages are fine for small changes. However, bigger changes should look like this:

    $ git commit -m "A brief summary of the commit
    >
    > A paragraph describing what changed and its impact."

## Coding conventions

None to speak of: just follow RPM packager norms.
