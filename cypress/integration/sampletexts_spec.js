const sampletexts = require('../fixtures/sampletexts')
let checksampleTexts = function(fixture, label) {
    cy.visit('http://localhost:8984/vicav/#map=[biblMarkers,_samples_,]')
    cy.get('img.leaflet-marker-icon') // Wait until the initial markers appear.

    for (let l = 0; l < fixture.labels.length; l++) {
        cy.get('img[alt="'+ fixture.labels[l] + '"]').click({force: true});
    }

    cy.get('[data-snippetid=' + fixture.snippetid + '] .spSentence').as('sentences')

    cy.get('@sentences').then((sentences) => {
        for(let s = 0; s < sentences.length; s += 1) {
            let fixture_s = fixture.sentences[s]

            cy.get(sentences[s]).then(function(el) {
                assert.equal(el.text().replace(/(^\s+)|(\s+$)/g, '').replace(/\s/g, ' '), fixture_s)
            })
            for (let variant in fixture.variants) {
                cy.contains(variant).scrollIntoView().trigger('mouseover').then(function(el) {
                    cy.contains(fixture.variants[variant])
                });
            }
        }          
    })
}

describe('VICAV samples test', function() {
    for(let text in sampletexts) {
        it('Check ' + text + ' sentences', function() {
            // Write the number to input field
            checksampleTexts(sampletexts[text], text)
        })
    }
})