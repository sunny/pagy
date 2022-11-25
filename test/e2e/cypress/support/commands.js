// ***********************************************
// This example commands.js shows you how to
// create various custom commands and overwrite
// existing commands.
//
// For more comprehensive examples of custom
// commands please read more here:
// https://on.cypress.io/custom-commands
// ***********************************************
//
//
// -- This is a parent command --
// Cypress.Commands.add('login', (email, password) => { ... })
//
//
// -- This is a child command --
// Cypress.Commands.add('drag', { prevSubject: 'element'}, (subject, options) => { ... })
//
//
// -- This is a dual command --
// Cypress.Commands.add('dismiss', { prevSubject: 'optional'}, (subject, options) => { ... })
//
//
// -- This will overwrite an existing command --
// Cypress.Commands.overwrite('visit', (originalFn, url, options) => { ... })

require('@cypress/snapshot').register();
import 'cypress-html-validate/dist/commands';

Cypress.Commands.add('snapId', (id) => {
  cy.get('#records').snapshot();
  cy.get(id).snapshot({ json: false });
})

Cypress.Commands.add('navStyleId', (style, id) => {
  cy.visit(style);
  cy.snapId(id);

  if (style === '/materialize' || style === '/semantic') {
    cy.get(id + ' a:last').click();
  } else {
    cy.get(id).contains('Next').click();
  }
  cy.snapId(id);

  cy.get(id).contains('3').click();
  cy.snapId(id);

  cy.get(id).contains('50').click();
  cy.snapId(id);


  if (style === '/materialize' || style === '/semantic') {
    cy.get(id + ' a:first').click();
  } else {
    cy.get(id).contains('Prev').click();
  }
  cy.snapId(id);
})

Cypress.Commands.add('comboNavStyle', (style) => {
  const id = '#combo-nav-js'
  cy.visit(style);
  cy.snapId(id);

  if (style === '/materialize' || style === '/semantic') {
    cy.get(id + ' a:last').click();
  } else {
    cy.get(id).contains('Next').click();
  }
  cy.snapId(id);

  cy.get(id + ' input').type('3{enter}');
  cy.snapId(id);

  cy.get(id + ' input').type('50').blur();
  cy.snapId(id);

  cy.get(id + ' input').focus().type('{downarrow}{enter}');
  cy.snapId(id);

  if (style === '/materialize' || style === '/semantic') {
    cy.get(id + ' a:first').click();
  } else {
    cy.get(id).contains('Prev').click();
  }
  cy.snapId(id);
})
