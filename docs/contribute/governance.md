# Governance

<!--- cSpell:ignore Kanban Zenhub -->

## Roles and responsibilities

As mentioned above, we value participation from anyone that is interested in this space. For the
Cloud-Native Toolkit participation can take on a number of different forms. The following
roles detail a number of ways in which people might interact with the Toolkit.

### Consumers

_Consumers_ are members of the community who are applying assets to their development projects. Anyone who wants to apply any of the assets can be a user. We encourage consumers to participate as evangelists and contributors as well.

### Evangelists

*Evangelists* are members of the community who help others become consumers of the assets. They do so by:

- Advertising the assets and encouraging others to use them
- Supporting new consumers and answering questions, such as on Slack (IBM internal)
- Reporting bugs or missing features through GitHub issues

### Contributors

*Contributors* are members of the community who help maintain, improve, and expand the assets. In addition to using and evangelizing the assets, they make the assets better by:

- Resolving issues in GitHub to fix bugs, add features, and improve documentation
- Submitting changes as GitHub pull requests

### Maintainers

*Project maintainers* (aka maintainers) are owners of the project who are committed to the success of the assets in that project. Each project has a team of maintainers, and each team has a lead. In addition to their participation as contributors, maintainers have privileges to:

- Label, close, and manage GitHub issues
- Close and merge GitHub pull requests
- Nominate and vote on new maintainers

## Types of teams

### Core team

Core team members are IBM employees responsible for the leadership and strategic direction of the set of Catalyst projects as a whole. The core team also directs how the Catalyst strategy will evolve with IBM Cloud product decisions. Core team responsibilities include:

- Actively engaging with the projects' communities
- Setting overall direction and vision
- Setting priorities and release schedule
- Focusing on broad, cross-cutting concerns
- Spinning up or shutting down project teams

The core team will operate the technical steering committee.

#### Technical steering committee

The technical steering committee coordinates the project teams to ensure consistency between the projects and fosters collaboration between the core team and each project team. This close communication on cross-cutting concerns greatly mitigates the risk of misalignment that can come from decentralized efforts. The committee consists of the project leads of all of the projects as well as other members of the core team who may not presently be leading any projects.

### Project teams

Each project team maintains the assets in its project. Therefore, its members are the maintainers of the assets. Each project operates independently, though it should follow this governance structure to define roles, responsibilities, and decision-making protocols.

The project has a project lead, a lead maintainer who should also be a member of the technical steering committee.

Each project lead is responsible for:

- Acting as a point of primary contact for the team
- Participating in the technical steering committee
- Deciding on the initial membership of project maintainers (in consultation with the core team)
- Determining and publishing project team policies and mechanics, including the way maintainers join and leave the team (which should be based on team consensus)
- Communicating core vision to the team
- Ensuring that issues and pull requests progress at a reasonable rate
- Making final decisions in cases where the team is unable to reach consensus (should be rare)

The way that project teams communicate internally and externally is left to each team, but:

- Technical discussion should take place in the public domain as much as possible, ideally in GitHub issues and pull requests.
- Each project should have a dedicated Slack channel (IBM internal). Decisions from Slack discussions should be captured in GitHub issues.
- Project teams should actively seek out discussion and input from stakeholders who are not members of the team.

## Project Governance

### Planning

Project planning is managed in a [Kanban board](https://en.wikipedia.org/wiki/Kanban_board), specifically this Zenhub board:

- [Planning Zenhub](https://github.com/cloud-native-toolkit/planning)

### Decision-making

Project teams should use [consensus decision making](#consensus) as much as possible, but resort to [lack of consensus decision making](#lack-of-consensus) when necessary.

#### Consensus

Project teams use [consensus decision-making](http://en.wikipedia.org/wiki/Consensus_decision-making) with the premise that a successful outcome is not where one side of a debate has "won," but rather where concerns from *all* sides have been addressed in some way. **This emphatically does not mean design by committee, nor compromised design.** Rather, it's a recognition that every design or implementation choice carries a trade-off and numerous costs. There is seldom a 100% right answer.

Breakthrough thinking sometimes end up changing the playing field by eliminating tradeoffs altogether, but more often, difficult decisions have to be made. **The key is to have a clear vision and set of values and priorities**, which is the core team's responsibility to set and communicate, and the project teams' responsibility to act upon.

Whenever possible, seek to reach consensus through discussion and design iteration. Concretely, the steps are:

- New GitHub issue or pull request is created with initial analysis of tradeoffs.
- Comments reveal additional drawbacks, problems, or tradeoffs.
- The issue or pull request is revised to address comments, often by improving the design or implementation.
- Repeat above until "major objections" are fully addressed, or it's clear that there is a fundamental choice to be made.

Consensus is reached when most people are left with only "minor" objections. While they might choose the tradeoffs slightly differently, they do not feel a strong need to *actively block* the issue or pull request from progressing.

One important question is: consensus among which people, exactly? Of course, the broader the consensus, the better. When a decision in a project team affects other teams (e.g. new/changed API), the team will be encouraged to invite people (e.g. leads) from affected teams. But at the very least, **consensus within the members of the project team should be the norm for most decisions**. If the core team has done its job of communicating the values and priorities, it should be possible to fit the debate about the issue into that framework and reach a fairly clear outcome.

#### Lack of consensus

In some cases, though, consensus cannot be reached. These cases tend to split into two very different camps:

- **"Trivial" reasons**, e.g., there is not widespread agreement about naming, but there is consensus about the substance.
- **"Deep" reasons**, e.g., the design fundamentally improves one set of concerns at the expense of another, and people on both sides feel strongly about it.

In either case, an alternative form of decision-making is needed.

- For the "trivial" case, the project lead will make an executive decision or defer the decision to another maintainer on the team.
- For the "deep" case, the project lead is empowered to make a final decision, but should consult with the core team before doing so.

### Contribution process

Catalyst assets are typically stored in GitHub repositories and use a [fork and pull request](https://guides.github.com/activities/forking/) workflow for contributions. Specific instructions can be found in each project's GitHub `CONTRIBUTING.md` file.

### Contributor License Agreement

We require contributors outside of IBM to sign our Contributor License Agreement (CLA) before code contributions can be reviewed and merged.
