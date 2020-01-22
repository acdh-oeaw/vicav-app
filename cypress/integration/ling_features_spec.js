describe('Features', function() {
    it('should show clickable markers', function() {
	    cy.visit('http://localhost:8984/vicav/#map=[biblMarkers,_features_,]')
	    cy.get('img.leaflet-marker-icon') // Wait until the initial markers appear.

	    cy.get('img[alt^="Tunis"]').click({force: true})
	    cy.get('[data-snippetid="ling_features_tunis"]').contains('h2', 'A List of Linguistic Features of Tunis Arabic')
    });
})

describe('Features XSLT', function() {
    it('should output the table', function() {
    	cy.fixture('api/lingfeatures_Test_body.xml').then(tunisBody => {
		    cy.request('http://localhost:8984/vicav/profile?coll=vicav_lingfeatures&id=ling_features_test&xslt=features_01.xslt').as('ling_features_test')
		    cy.get('@ling_features_test').then(response => {
		    	expect(response.body.replace(/\s*(\r\n|\n|\r)\s*/gm, '')).to.eq(tunisBody.replace(/\s*(\r\n|\n|\r)\s*/gm, ''))
		    })
    	})
    });
})

describe('Features Comparison', function() {
    it('should output the comparison table', function() {
		cy.visit('http://localhost:8984/vicav/#map=[biblMarkers,_features_,]')
		cy.get('button.navbar-toggler').click().then(() => {
			cy.contains('Feature Lists').click().then(() => {
				cy.contains('Cross-examine the VICAV Feature Lists').scrollIntoView().click().then(() => {
					cy.contains('who?').click().then(() => {
						cy.contains('Ahwaz')
						cy.contains('Baghdad')
						cy.contains('hāḏa r-rayyāl yāhu? / yāhu hāḏa r-rayyāl? / zəlma– əhwa ṣāḥbi.')
						cy.contains('(Who is this man? – He is my friend)')								
					});
				});
			});
		})
    });

    it('should support phrases', function() {
		cy.visit('http://localhost:8984/vicav/#map=[biblMarkers,_features_,]')
		cy.get('button.navbar-toggler').click().then(() => {
			cy.contains('Feature Lists').click().then(() => {
				cy.contains('Cross-examine the VICAV Feature Lists').scrollIntoView().click().then(() => {
					cy.contains('how?').click().then(() => {
						cy.contains('Ahwaz')
						cy.contains('Baghdad')
						cy.contains('šlōn ək? / šlōnəč? (f.) – zīən. / zīəna.')
						cy.contains('(How are you (m./f.)? – I’m fine.)')								
					});
				});
			});
		})
    });
})