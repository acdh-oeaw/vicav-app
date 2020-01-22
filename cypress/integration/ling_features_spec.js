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
