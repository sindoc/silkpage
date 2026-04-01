# Commercial Licensing

SilkPage is being prepared to support a classic dual-licensing model:

- Open source distribution under the GNU General Public License.
- Separate commercial licenses for customers who need rights beyond the GPL.

This is the same broad model used by products such as MySQL: a GPL path for
open-source use and a commercial path for proprietary embedding,
redistribution, or support arrangements.

This file is a project policy statement and implementation note. It is not, by
itself, a commercial license grant.

## Preconditions

Dual licensing only works cleanly if the commercial licensor controls the
necessary copyright in the codebase. In practice SilkPage needs all of the
following:

- A clearly identified copyright holder for the project.
- Inbound contributor terms that permit commercial relicensing.
- A third-party dependency inventory with license compatibility verified.
- Separate treatment for software, documentation, templates, and website
  content.

## Repository Intent

The intended licensing split is:

- SilkPage core software: GPL plus commercial license.
- SilkPage documentation: separate documentation license, unless explicitly
  relicensed by the rights holder.
- Website content and marketing copy: separate content license.
- User templates and example sites: separate template/content license unless
  explicitly included in the dual-licensed software scope.

## Operational Requirements

Before offering commercial licenses, the project should maintain:

- A contributor agreement or assignment process for non-trivial contributions.
- A signed commercial license form maintained outside the repository.
- Published trademark rules for the SilkPage name and logos.
- Third-party notices for bundled libraries and redistributed assets.

Supporting repository documents:

- `CONTRIBUTING.md`
- `legal/CLA-Individual.md`
- `legal/CLA-Corporate.md`
- `LICENSES/README.md`

## Current Status

This repository now documents the dual-licensing intent, but legal review is
still required before treating the commercial path as fully operational.
