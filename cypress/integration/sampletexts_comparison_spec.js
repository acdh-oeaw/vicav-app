//const sampletexts = require('../fixtures/sampletexts')
import chaiColors from 'chai-colors'
chai.use(chaiColors)

describe('VICAV Compare samples window', function() {
	it ('shows form with the right behavior', function() {
	    cy.visit('http://localhost:8984/vicav/compare-samples.html')
	    cy.get('.location-wrapper .tagit input').type('Tun')
	    cy.get('.tagit-autocomplete .ui-menu-item').then(() => {
		    cy.contains('Tunis2').click()
	    })

	    cy.get('.word-wrapper .tagit input').type('tn')
	    cy.get('.tagit-autocomplete .ui-menu-item').then(() => {
		    cy.contains('ṯnīn').click()
	    })

	    cy.get('.person-wrapper .tagit input').type('Tes')
	    cy.get('.tagit-autocomplete .ui-menu-item').then(() => {
		    cy.contains('Test1/m/20').click()
	    })

	    cy.get('.sentences-wrapper [type=text]').type('1')
	    cy.contains('Compare texts').click()
    	cy.url().should('eq', 'http://localhost:8984/vicav/compare-samples.html?location=Tunis2&age=&person=Test1&sentences=1&word=i%E1%B9%AFn%C4%ABn') 
	}) 

	it('supports locations', () => {
		cy.visit('http://localhost:8984/vicav/compare-samples.html?location=Tunis2,Test&age=&person=&sentences=&word=')

		cy.contains('nhāṛ l-iṯnēn baʕd ṣlǟt il-fažⁱr mšēt l-is-sūg w-šrēt šwayy ʕḏ̣am w-xuḏ̣ṛa, šwayy biḏinžǟn w-ʕūlti m-iṯ-ṯūm.')
		cy.contains('w-šrīt zūz kīlu burgdǟn b-sūm munǟsib f-is-sūq.')
		// Region
		cy.contains('Siliana')
	})


	it('should only show the given sentences ', () => {
		cy.visit('http://localhost:8984/vicav/compare-samples.html?location=Tunis2&age=&person=&sentences=2&word=')
		cy.contains('šrīt zūz kīlu buṛdgāna b-dīnāṛ zāda.')
		cy.contains('nhāṛ l-iṯnēn baʕd ṣlǟt').should('not.exist')
	})

	it ('supports wildcards and highlights in word search', () => {
		cy.visit('http://localhost:8984/vicav/compare-samples.html?location=Tunis2%2CTest&age=&person=&sentences=&word=b%2Ain%C5%BE%2A')
		cy.get('.results .spSentence').then(() => {
			cy.contains('span', 'biḏinžǟn').should('have.css', 'color').and('be.colored', 'red')
			cy.contains('span', 'bītinžāl').should('have.css', 'color').and('be.colored', 'red')
		})
	})


	it ('supports search by gender', () => {
		cy.visit('http://localhost:8984/vicav/compare-samples.html?location=Tunis2%2CTest&sex=f')
		cy.get('.results .spSentence').then(() => {
			cy.contains('Test1/m/20').should('not.exist')
			cy.contains('Test2/f/40')
		})
	})

	it ('supports search by gender', () => {
		cy.visit('http://localhost:8984/vicav/compare-samples.html?location=Tunis2%2CTest&age=0,30')
		cy.get('.results .spSentence').then(() => {
			cy.contains('Test2/f/40').should('not.exist')
			cy.contains('Test1/m/20')
		})
	})

})

