const sampletexts = require('../fixtures/sampletexts')
let checksampleTexts = function(fixture, label) {
    cy.visit('http://localhost:8984/vicav/#map=[biblMarkers,_samples_,]')
    cy.get('#cookie-overlay').should('be.visible')
    cy.get('.cookie-accept-btn').click()
    cy.get('#cookie-overlay').should('not.be.visible')
    cy.get('img.leaflet-marker-icon').should('be.visible') // Wait until the initial markers appear.

    for (let l = 0; l < fixture.labels.length; l++) {
        cy.get('img[alt="'+ fixture.labels[l] + '"]').click({force: true});
    }

    if (fixture.person !== undefined) {
        cy.get('[data-snippetid=' + fixture.snippetid + '] i').as('snippet')
        cy.get('@snippet').contains(fixture.person);
        cy.get('@snippet').contains(fixture.sex)
        cy.get('@snippet').contains(fixture.age);
    }

    cy.get('[data-snippetid=' + fixture.snippetid + '] .spSentence').as('sentences')

    cy.get('@sentences').each((sentence, s) => {
        let fixture_s = fixture.sentences[s]

        cy.get(sentence).scrollIntoView().should(($el) => {
            assert.equal($el.text().replace(/(^\s+)|(\s+$)/g, '').replace(/\s/g, ' '), fixture_s)
        })
    })

    for (let variant in fixture.variants) {
        cy.contains(variant).scrollIntoView().trigger('mouseover').then(($el) => {
            let toolTipID = $el.attr('aria-describedBy')
            if (toolTipID === undefined) {
                toolTipID = $el.find('span').attr('aria-describedBy')
            }
            if (toolTipID === undefined) {
                toolTipID = $el.closest('span').attr('aria-describedBy')
            }
            cy.get('#'+toolTipID).contains(fixture.variants[variant])
            // At the end of this test we have to move the virtual mouse away.
            // We can just pretend we have a lot of mouse cursors and not move away.
            // In this case that creates a situation where elements created by mouseover
            // seem to be stacked on one another. The next mouseover trigger then will fail.
            .then(() => {
                // chaining this with .trigger() did not work.
                $el.trigger('mouseout')
                cy.log('TRIGGER mouseout')
            })
        })
    }

}

describe('VICAV samples test', function() {
    for(let text in sampletexts) {
        it('Check ' + text + ' sentences', function() {
            // Write the number to input field
            checksampleTexts(sampletexts[text], text)
        })
    }
})