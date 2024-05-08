describe('Dictionaries', function() {
    it('should show clickable markers', function() {
	    cy.visit('http://localhost:8984/vicav/#map=[biblMarkers,_vicavDicts_,]')
	    cy.get('img.leaflet-marker-icon') // Wait until the initial markers appear.

	    cy.get('img[alt^="Tunis"]').click({force: true})
	    cy.get('[data-snippetid="dictFrontPage_Tunis"]').contains('i', 'TUNICO')
    });
})
