package my.maxent.internal;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import opennlp.model.AbstractDataIndexer;
import opennlp.model.ComparableEvent;
import opennlp.model.Event;
import opennlp.model.EventStream;
import opennlp.model.OnePassDataIndexer;

import org.knime.core.node.ExecutionMonitor;

/**
 * Replaces the original OnePassDataIndexer from OpenNLP project
 * because the original implementation printed debug messages directly
 * to the standard output.
 * @author Viliam Simko
 */
public class KnimeProgressDataIndexer extends AbstractDataIndexer {

	private final ExecutionMonitor monitor;

	/**
	 * @see OnePassDataIndexer#OnePassDataIndexer(EventStream, int, boolean)
	 */
	public KnimeProgressDataIndexer(ExecutionMonitor monitor, final EventStream eventStream, final int cutoff, final boolean sort) {
	
		this.monitor = monitor;
		
		final Map<String, Integer> predicateIndex = new HashMap<>();

		try {
			monitor.setMessage("Computing event counts...");
			final LinkedList<Event> events = computeEventCounts(eventStream, predicateIndex, cutoff);
			
			monitor.setMessage("Indexing predicates...");
			final List<ComparableEvent> eventsToCompare = index(events, predicateIndex);
			
			monitor.setMessage("Sorting and merging events...");
			sortAndMerge(eventsToCompare, sort);

		} catch(final IOException e) {
			// silently ignored
		}
		monitor.setMessage("Done indexing.");
	}

	private int numEvents;
	
	@Override
	public int getNumEvents() {
		return numEvents;
	}

	/**
	 * We had to duplicate also this method from {@link AbstractDataIndexer} because
	 * it printed a message to stdout. We are now using {@link ExecutionMonitor} instead.
	 * 
	 * @see AbstractDataIndexer
	 */
	protected int sortAndMerge(List<ComparableEvent> eventsToCompare, boolean sort) {
		int numUniqueEvents = 1;
		numEvents = eventsToCompare.size();
		if (sort) {
			Collections.sort(eventsToCompare);
			if (numEvents <= 1) {
				return numUniqueEvents; // nothing to do; edge case (see
										// assertion)
			}

			ComparableEvent ce = eventsToCompare.get(0);
			for (int i = 1; i < numEvents; i++) {
				ComparableEvent ce2 = eventsToCompare.get(i);

				if (ce.compareTo(ce2) == 0) {
					ce.seen++; // increment the seen count
					eventsToCompare.set(i, null); // kill the duplicate
				} else {
					ce = ce2; // a new champion emerges...
					numUniqueEvents++; // increment the # of unique events
				}
			}
		} else {
			numUniqueEvents = eventsToCompare.size();
		}
		
		if (sort) {
			monitor.setMessage("Reduced " + numEvents + " events to " + numUniqueEvents);
		}

		contexts = new int[numUniqueEvents][];
		outcomeList = new int[numUniqueEvents];
		numTimesEventsSeen = new int[numUniqueEvents];

		for (int i = 0, j = 0; i < numEvents; i++) {
			ComparableEvent evt = eventsToCompare.get(i);
			if (null == evt) {
				continue; // this was a dupe, skip over it.
			}
			numTimesEventsSeen[j] = evt.seen;
			outcomeList[j] = evt.outcome;
			contexts[j] = evt.predIndexes;
			++j;
		}
		return numUniqueEvents;
	}
	
	/**
	 * @see OnePassDataIndexer#computeEventCounts(EventStream, Map, int)
	 */
	private LinkedList<Event> computeEventCounts(final EventStream eventStream, final Map<String, Integer> predicatesInOut, final int cutoff) throws IOException {
		final Set<String> predicateSet = new HashSet<>();
		final Map<String, Integer> counter = new HashMap<String, Integer>();
		final LinkedList<Event> events = new LinkedList<Event>();
		while (eventStream.hasNext()) {
			Event ev = eventStream.next();
			events.addLast(ev);
			update(ev.getContext(), predicateSet, counter, cutoff);
		}
		predCounts = new int[predicateSet.size()];
		int index = 0;
		for (Iterator<String> pi = predicateSet.iterator(); pi.hasNext(); index++) {
			final String predicate = pi.next();
			predCounts[index] = counter.get(predicate);
			predicatesInOut.put(predicate, index);
		}
		return events;
	}

	/**
	 * @see OnePassDataIndexer#index(LinkedList, Map)
	 */
	protected List<ComparableEvent> index( final LinkedList<Event> events, final Map<String, Integer> predicateIndex) {

		final Map<String, Integer> omap = new HashMap<String, Integer>();

		final int numEvents = events.size();
		final List<ComparableEvent> eventsToCompare = new ArrayList<>(numEvents);
		final List<Integer> indexedContext = new ArrayList<Integer>();

		int outcomeCount = 0;
		
		for (int eventIndex = 0; eventIndex < numEvents; eventIndex++) {
			final Event ev = events.removeFirst();
			final String[] econtext = ev.getContext();
			ComparableEvent ce;

			int ocID;
			final String oc = ev.getOutcome();

			if (omap.containsKey(oc)) {
				ocID = omap.get(oc);
			} else {
				ocID = outcomeCount++;
				omap.put(oc, ocID);
			}

			for (int i = 0; i < econtext.length; i++) {
				final String pred = econtext[i];
				if (predicateIndex.containsKey(pred)) {
					indexedContext.add(predicateIndex.get(pred));
				}
			}

			// drop events with no active features
			if (indexedContext.size() > 0) {
				final int[] cons = new int[indexedContext.size()];
				for (int ci = 0; ci < cons.length; ci++) {
					cons[ci] = indexedContext.get(ci);
				}
				ce = new ComparableEvent(ocID, cons);
				eventsToCompare.add(ce);
			}
			
			// recycle the TIntArrayList
			indexedContext.clear();
		}
		outcomeLabels = toIndexedStringArray(omap);
		predLabels = toIndexedStringArray(predicateIndex);
		return eventsToCompare;
	}
}
