//const sampletexts = require('../fixtures/sampletexts')
import chaiColors from 'chai-colors'
chai.use(chaiColors)

describe('VICAV Compare samples window', function() {
	it ('shows form with the right behavior', function() {
	    cy.visit('http://localhost:8984/vicav/')

		cy.get('button.navbar-toggler').click().then(() => {
			cy.contains('Samples').click().then(() => {
				cy.contains('Compare Locations').click().then(() => {
				    cy.get('.location-wrapper .tagit input').type('Tun', {force: true})
				    cy.get('.tagit-autocomplete .ui-menu-item').then(() => {
					    cy.contains('Tunis2').click()
				    })

				    cy.get('.word-wrapper .tagit input').scrollIntoView().type('nh', {force: true})
				    cy.get('.tagit-autocomplete .ui-menu-item').then(() => {
					    cy.contains('nhāṛ').click()
				    })

				    cy.get('[name="sex"][value=f]').click()
				    cy.get('[name="sex"][value=m]').click()

				    cy.get('.person-wrapper .tagit input').scrollIntoView().type('Tes', {force: true})
				    cy.get('.tagit-autocomplete .ui-menu-item').then(() => {
					    cy.contains('Test1/m/20').click()
				    })

				    cy.get('.features-wrapper [type=text]').type('1')
				    cy.contains('Compare texts').click()
				    cy.get('[data-snippetID=compare-samples-result]').then((el) => {
				    	cy.url().should('contain', '[crossSamplesResult,xslt|cross_samples_01.xslt+location|Tunis2+age|0%2C100+person|Test1+features|1+word|nh%C4%81%E1%B9%9B+sex|,open]')	
				    	cy.get(el).contains('nhāṛ li-ṯnīn baʕd il-fažr əmšīt l-is-sūq bāš nišri ʕ9am w-xu9ṛa kīma bītinžāl w-ṯūm.')
				    	cy.get(el).contains('Siliana')
				    })
				});
			});
		});

	}) 


	it('should only show the given sentences ', () => {
		cy.visit('http://localhost:8984/vicav/#map=[biblMarkers,_samples_,]&1=[crossSamplesResult,location|Tunis2+age|0%2C100+person|+features|2+word+xslt|cross_samples_01.xslt,open]')
		cy.get('[data-snippetID=compare-samples-result]')
			.contains('šrīt zūz kīlu buṛdgāna b-dīnāṛ zāda.')
			.contains('nhāṛ li-ṯnīn baʕd il-fažr əmšīt l-is-sūq bāš nišri ʕ9am w-xu9ṛa kīma bītinžāl w-ṯūm.').should('not.exist');
	})

	it ('supports wildcards and highlights in word search', () => {
		cy.visit('http://localhost:8984/vicav/#map=[biblMarkers,_samples_,]&1=[crossSamplesResult,location|Tunis2%2CTest+age|+person|+features|+word|b%2Ain%C5%BE%2A+xslt|cross_samples_01.xslt, open]')
		cy.get('[data-snippetID=compare-samples-result]').contains('span', 'biḏinžǟn').should('have.css', 'color').and('be.colored', 'red')
		cy.get('[data-snippetID=compare-samples-result]').contains('span', 'bītinžāl').should('have.css', 'color').and('be.colored', 'red')
	})

	it ('supports search by gender', () => {
		cy.visit('http://localhost:8984/vicav/#map=[biblMarkers,_samples_,]&1=[crossSamplesResult,location|Test+age|+person|+features|+word|+sex|f+xslt|cross_samples_01.xslt, open]')
		cy.get('[data-snippetID=compare-samples-result]').then(() => {
			cy.contains('Test1/m/20').should('not.exist')
			cy.contains('Test2/f/40')
		})
	})

	it ('supports search by age', () => {
		cy.visit('http://localhost:8984/vicav/#map=[biblMarkers,_samples_,]&1=[crossSamplesResult,location|Test+age|0%2c30+person|+features|+word|+sex|+xslt|cross_samples_01.xslt, open]')
		cy.get('[data-snippetID=compare-samples-result]').then(() => {
			cy.contains('Test2/f/40').should('not.exist')
			cy.contains('Test1/m/20')
		})
	})

})

