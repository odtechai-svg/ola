export interface VersionedSentence {
  sentenceId: string;
  version: number;
  text: string;
  sourceGloss: string;
  status: "draft" | "reviewed" | "published";
  validFrom: string;
}

export function nextSentenceVersion(previous: VersionedSentence, patch: Pick<VersionedSentence, "text" | "sourceGloss" | "status">): VersionedSentence {
  return {
    ...previous,
    ...patch,
    version: previous.version + 1,
    validFrom: new Date().toISOString()
  };
}
