describe('Regional bibliography', function() {
    it('should come up functioning on front page', function() {
	    cy.visit('http://localhost:8984/vicav/#map=[biblMarkers,.*,reg]')
	    cy.get('path.leaflet-interactive') // Wait until the initial markers appear.

	    cy.get('path[d="M304.4000000000001,209.16999788329076a11,11 0 1,0 22,0 a11,11 0 1,0 -22,0 "]')
	    	.scrollIntoView()
	    	.trigger('mouseover', {force: true})
	    	.then(function (el) {
		    	cy.contains('Tunisia')
		    	cy.get(el).click({force: true})
		    cy.contains('reg:Tunisia,.*')
		    cy.get('.dvBibBook')
		})
    })
})