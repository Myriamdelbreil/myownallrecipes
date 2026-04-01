# Problem statement

### _It's dinner time!_ Create an application that helps users find the most relevant recipes that they can prepare with the ingredients that they have at home

## Objective

Deliver a prototype web application to answer the above problem statement.

__✅ Must have's__

- A back-end with Ruby on Rails (If you don't know Ruby on Rails, refer to the FAQ)
- A PostgreSQL relational database
- A well-thought user experience

__🚫 Don'ts__

- Excessive effort in styling
- Features which don't directly answer the above statement
- Over-engineer your prototype

## Deliverable

- The codebase should be pushed on the current GitHub private repository.
- 2 or 3 user stories that address the statement in your repo's `README.md`.
- The application accessible online (a personal server, fly.io or something else). If you can't deploy your app online, refer to the FAQ)
- Submission of the above via [this form](https://forms.gle/siH7Rezuq2V1mUJGA).
- If you're on Mac, make sure your browser has [permission to share the screen](https://support.apple.com/en-al/guide/mac-help/mchld6aa7d23/mac).


## Data

Please start from the following dataset to perform the assignment:
[english-language recipes](https://pennylane-interviewing-assets-20220328.s3.eu-west-1.amazonaws.com/recipes-en.json.gz) scraped from www.allrecipes.com with [recipe-scrapers](https://github.com/hhursev/recipe-scrapers)

Download it with this command if the above link doesn't work:
```sh textWrap
wget https://pennylane-interviewing-assets-20220328.s3.eu-west-1.amazonaws.com/recipes-en.json.gz && gzip -dc recipes-en.json.gz > recipes-en.json
```

## FAQ

<details>
<summary><i>I'm a back-end developer or don't know React, what do I do?</i></summary>

Just make the simplest UI, style isn't important and server rendered HTML pages will do!
</details>

<details>
<summary><i>Can I have a time extension for the test?</i></summary>

No worries, we know that unforeseen events happen, simply reach out to the recruiter you've been
talking with to discuss this.
</details>

<details>
<summary><i>Can I transform the dataset before seeding it in the DB</i></summary>

Absolutely, feel free to post-process the dataset as needed to fit your needs.
</details>

<details>
<summary><i>Should I rather implement option X or option Y</i></summary>

That decision is up to you and part of the challenge. Please document your choice
to be able to explain your reflexion and choice to your interviewer for the
challenge debrief.
</details>

<details>
<summary><i>Do I really have to deploy the application online?</i></summary>
Deploying the application does ensure a smooth interview experience by allowing interviewers to test your code live. However, you should not overinvest time (or money) on this if you really can't figure it. You can alternatively provide demo videos as a worst case option, as interviewers won't checkout and run the application to cover for missing demo or online version. In case you don't have an online application, please make sure everything is working smoothly
locally before your debrief interview.

</details>

<details>
<summary><i>I don't know <b>Ruby on Rails</b></i></summary>

That probably means you're applying for a managerial position, so it's fine to
pick another language of your choice to perform this task.
</details>

<details>


<summary><i>Can I use AI tools?</b></i></summary>

You are free to use AI tools to assist you in completing this case study. To maintain transparency, please document which AI tools you used during the assignment.

For each tool, briefly explain:
- The main tasks or problems for which you used it.
- How you validated and refined any AI-generated code.

Note: While AI can be a valuable assistant, interviewers will assess your ability to understand the entire codebase, explain key technical choices, and effectively answer technical questions about improvements. We expect candidates to use AI as a supportive tool rather than having it generate the complete solution. AI should supplement your coding process, not replace your critical thinking and hands-on development work.

### Choices and stances

## Design Choices

**No recipe instructions stored in the app**
Rather than storing and displaying full cooking instructions, the app redirects users to the original AllRecipes page. This keeps the database lean and avoids duplicating content that is already well presented on the source site.

---

## User Testing

The app was tested by real users during development. Their feedback was used to refine the user stories and user flow — in particular around the search experience and the clarity of the results page.

---

## Main User Flow

1. The user lands on the **homepage** → they see a search bar and quick-access shortcuts for popular ingredients (chicken, cheese, pasta...)

2. They **type one or more ingredients** in the combobox (autocomplete or free text) → selected ingredients appear as chips

3. They click **"Find and cook"** → they land on the results page with a list of matching recipes

4. They can **sort the results** by preparation time or number of ingredients to refine their choice

5. They click on a **recipe** → they see the prep time, cook time, and full ingredient list with quantities

6. They decide what to do next:
   - **"Find the steps"** → redirected to AllRecipes for the full recipe instructions
   - **"Have all you need delivered"** → redirected to Carrefour to order any missing ingredients
   - **"Share"** → share on Instagram, Facebook, Twitter or by email

---

## User Stories

**User Story 1 — Search recipes by ingredients**

As a user who wants to cook dinner without going to the store, I want to enter the ingredients I already have at home in a search bar, so that I get a list of recipes I can actually make right now.

- I can type or select one or multiple ingredients from a combobox
- I can add free text if my ingredient isn't in the list
- Each selected ingredient appears as a chip I can remove
- Results update to show only recipes that match my ingredients
- If no exact match is found, the app falls back to recipes using common base ingredients

---

**User Story 2 — Sort and refine results**

As a user browsing search results, I want to sort recipes by preparation time or number of ingredients, so that I can find something quick or something simple depending on my situation.

- I can sort by total prep time (ascending or descending)
- I can sort by number of ingredients (ascending or descending)
- The active sort is visually highlighted
- Sorting preserves my current ingredient search

---

**User Story 3 — View a recipe and take action**

As a user who found a recipe I like, I want to see its details and decide what to do next, so that I can either start cooking or get the missing ingredients delivered.

- I can see the prep time, cook time, and full ingredient list with quantities
- I can click a link to find the full cooking steps on AllRecipes
- I can click a link to get missing ingredients delivered via Carrefour
- I can share the recipe on social media or by email

---


## AI Usage

AI coding assistants were used throughout the project — for debugging, writing and structuring the README, refactoring, setting up CI, writing tests, and reviewing user stories. All suggested code changes were reviewed in the diff before being accepted and tested manually in the browser.

**Le Wagon UI component library**

- Used for UI components and styling conventions throughout the app

## What was added beyond the core requirements

**Error monitoring with Sentry**

Sentry was integrated to track and report runtime errors in production. This allows catching unexpected exceptions with full context (stack trace, user flow, environment) without needing to reproduce them locally.

---

**Recipe image handling (not merged — Render shell limitation)**

Work was done to fetch and store recipe images from AllRecipes with ActiveStorage and Cloudinary. However, it means running a huge migration requiring a lot of memory on the app in production.
Thus it has been chosen not to run this in production at the moment.

---

**GitHub Actions**
Work was done to setup a CI workflow to run tests on the app. Wasn't merged at the moment.
---

## Known issues

**Chip removal doesn't update search**

When returning to the search results page, previously selected ingredients are pre-filled in the combobox (chips displayed). However, removing a chip and re-submitting the form still sends the deleted ingredient in the request.

**Root cause:** `hw_combobox_tag` with `value:` pre-populates the hidden input, but chip removal doesn't update it in hotwire_combobox v0.4.1.

**To investigate:** upgrade `hotwire_combobox` or find a JS workaround to sync the hidden input on chip removal.

</details>
