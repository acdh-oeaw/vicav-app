const sampletexts = require('../fixtures/sampletexts')

let checksampleTexts = function(fixture) {
    cy.visit('http://localhost:8984/vicav')
    cy.get('img.leaflet-marker-icon') // Wait until the initial markers appear.
    
    cy.get('#subNavSamplesGeoRegMarkers').click()

    cy.get('img[alt='+ fixture.label + ']').click({force: true})
    cy.get('[data-snippetid=' + fixture.snippetid + '] .spSentence').as('sentences')

    cy.get('@sentences').then((sentences) => {
        for(let s = 0; s < sentences.length; s += 1) {
            let fixture_s = fixture.sentences[s]

            cy.get(sentences[s]).then(function(el) {
                assert.equal(el.text().replace(/\s/g, ' '), fixture_s)
            })
        }          
    })
}

describe('VICAV samples test', function() {
    for(let text in sampletexts) {
        it('Check ' + text + ' sentences', function() {
            // Write the number to input field
            checksampleTexts(sampletexts[text])
        })
    }
})