import iso191153.SxtSummaryFactory

def isoHandlers = new iso191153.Handlers(handlers, f, env)

SxtSummaryFactory.summaryHandler({it.parent() is it.parent()}, isoHandlers)

isoHandlers.addDefaultHandlers()
