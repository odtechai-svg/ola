import { AnalyticsEvent } from "@/lib/contracts/domain";

export function createEvent(name: AnalyticsEvent["name"], payload: AnalyticsEvent["payload"]): AnalyticsEvent {
  return {
    name,
    payload,
    at: new Date().toISOString()
  };
}
