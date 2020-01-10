describe('Features', function() {
    it('should show clickable markers', function() {
	    cy.visit('http://localhost:8984/vicav/#map=[biblMarkers,_features_,]')
	    cy.get('img.leaflet-marker-icon') // Wait until the initial markers appear.

	    cy.get('img[alt^="Tunis"]').click({force: true})
	    cy.get('[data-snippetid="ling_features_tunis"]').contains('h2', 'A List of Linguistic Features of Tunis Arabic')
    });
})
