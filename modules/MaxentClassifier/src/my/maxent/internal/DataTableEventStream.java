package my.maxent.internal;

import java.io.IOException;

import opennlp.model.Event;
import opennlp.model.EventStream;

import org.knime.core.data.DataRow;
import org.knime.core.data.RowIterator;
import org.knime.core.node.BufferedDataTable;
import org.knime.core.node.ExecutionMonitor;

/**
 * @author Viliam Simko
 */
public class DataTableEventStream implements EventStream {

	private final RowIterator rowIterator;
	private final String[] columnNames; // Important: We assume that the column names will not change during iteration.
	private final ExecutionMonitor monitor;
	
	private long currentRow;
	private long rowCount;

	public DataTableEventStream(final BufferedDataTable dataTable, final ExecutionMonitor monitor) {

		this.monitor = monitor;
		currentRow = 0;
		rowCount = dataTable.getRowCount();
		
		rowIterator = dataTable.iteratorFailProve();
		columnNames = dataTable.getDataTableSpec().getColumnNames();
	}
	
	/**
	 * This constructor is useful if we don't have {@link ExecutionMonitor}
	 * @param dataTable
	 */
	public DataTableEventStream(final BufferedDataTable dataTable) {
		monitor = null;
		rowIterator = dataTable.iteratorFailProve();
		columnNames = dataTable.getDataTableSpec().getColumnNames();
	}
	
	@Override
	public Event next() throws IOException {
		
		if(monitor != null) {
			monitor.setProgress(currentRow / rowCount);
		}
		
		final DataRow row = rowIterator.next();
		final int lastIdx = row.getNumCells() - 1;
		
		// outcome
		final String outcome = columnNames[lastIdx] + "=" + row.getCell(lastIdx);
		
		// context
		final String[] context = new String[lastIdx];
		for(int i=0; i < lastIdx; ++i) {
			context[i] = columnNames[i] + "=" + row.getCell(i).toString();
		}
		
		final Event event = new Event(outcome, context);
		return event;
	}

	@Override
	public boolean hasNext() throws IOException {
		return rowIterator.hasNext();
	}
	
	

}