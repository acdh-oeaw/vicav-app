describe('Features', function() {
    it('should show clickable markers', function() {
	    cy.visit('http://localhost:8984/vicav/#map=[biblMarkers,_features_,]')
	    cy.get('img.leaflet-marker-icon').then(function() {
		    cy.get('img[alt^="Tunis2"]').click({force: true}).then(function() {
			    cy.get('[data-snippetid="vicav_lingfeatures_tunis2"]').contains('h2', 'A List of Linguistic Features of Tunis2 Arabic')
		    })	    	
	    }) // Wait until the initial markers appear.
    });
})

describe('VICAV Compare features window', function() {
	it ('shows form with the right behavior', function() {
		cy.server()
		cy.route('vicav/data_locations*').as('resources')
		cy.route('vicav/explore_samples*').as('results')

	    cy.visit('http://localhost:8984/vicav/')

		cy.get('button.navbar-toggler').click().then(() => {
			cy.contains('Feature Lists').click().then(() => {
				cy.contains('Cross-examine the VICAV Feature Lists').click().then(() => {
					cy.wait('@resources').then((xhrs) => {
				    	cy.get('.location-wrapper .tagit input').scrollIntoView().type('Tun', {force: true})
					    cy.get('.tagit-autocomplete .ui-menu-item').then(() => {
							    cy.contains('Tunis2').click()
						    })

						    // cy.get('.word-wrapper .tagit input').scrollIntoView().type('sk', {force: true})
						    // cy.get('.tagit-autocomplete .ui-menu-item').then(() => {
							   //  cy.contains('škūn').click()
						    // })

						    cy.get('.person-wrapper .tagit input').scrollIntoView().type('Tes', {force: true})
						    cy.get('.tagit-autocomplete .ui-menu-item').then(() => {
							    cy.contains('Test1/f/45').click()
						    })

						    cy.get('.features-wrapper .tagit input').scrollIntoView().type('who', {force: true})
						    cy.get('.tagit-autocomplete .ui-menu-item').then(() => {
						    	cy.contains('who?').click()	
						    })

						    cy.contains('Compare features').click()
						    cy.wait('@results', {responseTimeout: 10000}).then(() => {
							    cy.get('[data-snippetID=compare-features-result]').then((el) => {
							    	cy.url().should('contain', '[crossFeaturesResult,type|lingfeatures+xslt|cross_features_02.xslt+location|Tunis2+age|0%2C100+person|Test1+features|semlib%3Awho+translation|+comment|+word|+sex|m%2Cf,open]')	
							    	cy.get(el).contains('2 feature sentences found.')
							    	cy.get('.tdFeaturesRightTarget').then((td) => {
							    		assert.equal(td[0].innerText, 'škūn hā -ṛ -ṛāžil?– hūwa ṣāḥbi.')
							    		assert.equal(td[1].innerText, 'škūn iṛ-ṛāžil hǟḏa? – hūwa ṣāḥbi.')
							    	})
							    	cy.get(el).contains('Jendouba')
							    })
						    })
					})			    	
				});
			});
		});
	}) 
})

