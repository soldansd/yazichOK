//
//  TestQuestion.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import Foundation

struct TestQuestion: Identifiable, Hashable {
    let id: String
    let topicID: String
    let question: String
    let options: [String]
    let correctAnswerIndex: Int
    let explanation: String

    init(id: String, topicID: String, question: String, options: [String], correctAnswerIndex: Int, explanation: String) {
        self.id = id
        self.topicID = topicID
        self.question = question
        self.options = options
        self.correctAnswerIndex = correctAnswerIndex
        self.explanation = explanation
    }
}

// MARK: - Mock Data
extension TestQuestion {
    static func mockQuestions(for topicID: String) -> [TestQuestion] {
        switch topicID {
        case "present-simple":
            return presentSimpleQuestions
        case "past-simple":
            return pastSimpleQuestions
        case "present-continuous":
            return presentContinuousQuestions
        case "articles":
            return articlesQuestions
        default:
            return defaultQuestions(for: topicID)
        }
    }

    private static let presentSimpleQuestions: [TestQuestion] = [
        TestQuestion(
            id: "ps-1",
            topicID: "present-simple",
            question: "Choose the correct form of the verb:\n\nMary usually _____ to work by bus.",
            options: ["goes", "go", "going", "went"],
            correctAnswerIndex: 0,
            explanation: "The third person singular (he/she/it) in Present Simple takes -s or -es at the end of the verb."
        ),
        TestQuestion(
            id: "ps-2",
            topicID: "present-simple",
            question: "Complete the sentence:\n\nThey _____ English every day.",
            options: ["study", "studies", "studying", "studied"],
            correctAnswerIndex: 0,
            explanation: "Plural subjects (they, we) use the base form of the verb in Present Simple."
        ),
        TestQuestion(
            id: "ps-3",
            topicID: "present-simple",
            question: "Which sentence is correct?",
            options: ["He don't like coffee.", "He doesn't like coffee.", "He doesn't likes coffee.", "He not like coffee."],
            correctAnswerIndex: 1,
            explanation: "Negative sentences in Present Simple use 'doesn't' for third person singular, followed by the base form of the verb."
        ),
        TestQuestion(
            id: "ps-4",
            topicID: "present-simple",
            question: "Fill in the blank:\n\nShe _____ to the gym three times a week.",
            options: ["go", "goes", "going", "gone"],
            correctAnswerIndex: 1,
            explanation: "Third person singular (she) requires the -es ending for the verb 'go' in Present Simple."
        ),
        TestQuestion(
            id: "ps-5",
            topicID: "present-simple",
            question: "Choose the correct question form:\n\n_____ you speak Spanish?",
            options: ["Do", "Does", "Are", "Is"],
            correctAnswerIndex: 0,
            explanation: "Questions in Present Simple use 'Do' with I/you/we/they and 'Does' with he/she/it."
        ),
        TestQuestion(
            id: "ps-6",
            topicID: "present-simple",
            question: "Complete:\n\nThe sun _____ in the east.",
            options: ["rise", "rises", "rising", "risen"],
            correctAnswerIndex: 1,
            explanation: "Third person singular subjects take the -s/-es ending in Present Simple."
        ),
        TestQuestion(
            id: "ps-7",
            topicID: "present-simple",
            question: "Which is correct?\n\n_____ your brother live in London?",
            options: ["Do", "Does", "Is", "Are"],
            correctAnswerIndex: 1,
            explanation: "Use 'Does' for questions with third person singular subjects in Present Simple."
        ),
        TestQuestion(
            id: "ps-8",
            topicID: "present-simple",
            question: "Complete the negative:\n\nWe _____ watch TV in the morning.",
            options: ["doesn't", "don't", "not", "aren't"],
            correctAnswerIndex: 1,
            explanation: "Negative sentences with plural subjects use 'don't' in Present Simple."
        ),
        TestQuestion(
            id: "ps-9",
            topicID: "present-simple",
            question: "Choose the correct form:\n\nMy cat _____ milk every day.",
            options: ["drink", "drinks", "drinking", "drank"],
            correctAnswerIndex: 1,
            explanation: "Third person singular (my cat/it) requires the -s ending in Present Simple."
        ),
        TestQuestion(
            id: "ps-10",
            topicID: "present-simple",
            question: "Fill in the blank:\n\nI _____ coffee in the morning.",
            options: ["drinks", "drink", "drinking", "drank"],
            correctAnswerIndex: 1,
            explanation: "First person singular (I) uses the base form of the verb in Present Simple."
        ),
        TestQuestion(
            id: "ps-11",
            topicID: "present-simple",
            question: "Which sentence is grammatically correct?",
            options: ["She work in a hospital.", "She works in a hospital.", "She working in a hospital.", "She is work in a hospital."],
            correctAnswerIndex: 1,
            explanation: "Third person singular requires -s ending in Present Simple."
        ),
        TestQuestion(
            id: "ps-12",
            topicID: "present-simple",
            question: "Complete:\n\nChildren _____ playing games.",
            options: ["like", "likes", "liking", "liked"],
            correctAnswerIndex: 0,
            explanation: "Plural subjects use the base form of the verb in Present Simple."
        ),
        TestQuestion(
            id: "ps-13",
            topicID: "present-simple",
            question: "Choose the correct negative:\n\nHe _____ eat meat.",
            options: ["don't", "doesn't", "not", "isn't"],
            correctAnswerIndex: 1,
            explanation: "Third person singular uses 'doesn't' in negative Present Simple sentences."
        ),
        TestQuestion(
            id: "ps-14",
            topicID: "present-simple",
            question: "Complete the question:\n\n_____ they live near here?",
            options: ["Does", "Do", "Are", "Is"],
            correctAnswerIndex: 1,
            explanation: "Plural subjects use 'Do' in Present Simple questions."
        ),
        TestQuestion(
            id: "ps-15",
            topicID: "present-simple",
            question: "Fill in the blank:\n\nWater _____ at 100 degrees Celsius.",
            options: ["boil", "boils", "boiling", "boiled"],
            correctAnswerIndex: 1,
            explanation: "Singular subjects (water/it) take the -s ending in Present Simple."
        ),
        TestQuestion(
            id: "ps-16",
            topicID: "present-simple",
            question: "Which is correct?\n\nMy parents _____ in the city.",
            options: ["lives", "live", "living", "lived"],
            correctAnswerIndex: 1,
            explanation: "Plural subjects use the base form of the verb in Present Simple."
        ),
        TestQuestion(
            id: "ps-17",
            topicID: "present-simple",
            question: "Choose the correct form:\n\n_____ she play tennis?",
            options: ["Do", "Does", "Is", "Are"],
            correctAnswerIndex: 1,
            explanation: "Third person singular uses 'Does' in Present Simple questions."
        ),
        TestQuestion(
            id: "ps-18",
            topicID: "present-simple",
            question: "Complete:\n\nI _____ understand this grammar rule.",
            options: ["doesn't", "don't", "not", "am not"],
            correctAnswerIndex: 1,
            explanation: "First person singular uses 'don't' in negative Present Simple sentences."
        ),
        TestQuestion(
            id: "ps-19",
            topicID: "present-simple",
            question: "Fill in the blank:\n\nThe train _____ at 9 AM every day.",
            options: ["leave", "leaves", "leaving", "left"],
            correctAnswerIndex: 1,
            explanation: "Singular subjects take the -s/-es ending in Present Simple."
        ),
        TestQuestion(
            id: "ps-20",
            topicID: "present-simple",
            question: "Which is grammatically correct?",
            options: ["You doesn't know him.", "You don't know him.", "You not know him.", "You doesn't knows him."],
            correctAnswerIndex: 1,
            explanation: "Second person (you) uses 'don't' with the base form in negative Present Simple."
        )
    ]

    private static let pastSimpleQuestions: [TestQuestion] = [
        TestQuestion(
            id: "past-1",
            topicID: "past-simple",
            question: "Choose the correct form:\n\nI _____ to Paris last year.",
            options: ["go", "went", "going", "goes"],
            correctAnswerIndex: 1,
            explanation: "The past simple of 'go' is 'went' (irregular verb)."
        ),
        TestQuestion(
            id: "past-2",
            topicID: "past-simple",
            question: "Complete:\n\nShe _____ a movie yesterday.",
            options: ["watch", "watches", "watched", "watching"],
            correctAnswerIndex: 2,
            explanation: "Regular verbs add -ed in Past Simple."
        ),
        TestQuestion(
            id: "past-3",
            topicID: "past-simple",
            question: "Which is correct?\n\nThey _____ the exam last week.",
            options: ["pass", "passed", "passing", "passes"],
            correctAnswerIndex: 1,
            explanation: "Regular verbs form Past Simple by adding -ed."
        )
    ]

    private static let presentContinuousQuestions: [TestQuestion] = [
        TestQuestion(
            id: "pc-1",
            topicID: "present-continuous",
            question: "Choose the correct form:\n\nShe _____ a book right now.",
            options: ["reads", "read", "is reading", "reading"],
            correctAnswerIndex: 2,
            explanation: "Present Continuous is formed with 'is/am/are + verb-ing'."
        ),
        TestQuestion(
            id: "pc-2",
            topicID: "present-continuous",
            question: "Complete:\n\nThey _____ football at the moment.",
            options: ["play", "plays", "are playing", "playing"],
            correctAnswerIndex: 2,
            explanation: "Plural subjects use 'are + verb-ing' in Present Continuous."
        )
    ]

    private static let articlesQuestions: [TestQuestion] = [
        TestQuestion(
            id: "art-1",
            topicID: "articles",
            question: "Choose the correct article:\n\nI saw _____ elephant at the zoo.",
            options: ["a", "an", "the", "no article"],
            correctAnswerIndex: 1,
            explanation: "Use 'an' before words that start with a vowel sound."
        ),
        TestQuestion(
            id: "art-2",
            topicID: "articles",
            question: "Complete:\n\n_____ sun rises in the east.",
            options: ["A", "An", "The", "No article"],
            correctAnswerIndex: 2,
            explanation: "Use 'the' with unique objects like the sun, the moon, etc."
        )
    ]

    private static func defaultQuestions(for topicID: String) -> [TestQuestion] {
        return [
            TestQuestion(
                id: "\(topicID)-1",
                topicID: topicID,
                question: "Sample question for this topic.\n\nChoose the correct answer:",
                options: ["Option A", "Option B", "Option C", "Option D"],
                correctAnswerIndex: 0,
                explanation: "This is a sample explanation for the correct answer."
            ),
            TestQuestion(
                id: "\(topicID)-2",
                topicID: topicID,
                question: "Another sample question.\n\nSelect the best option:",
                options: ["First choice", "Second choice", "Third choice", "Fourth choice"],
                correctAnswerIndex: 1,
                explanation: "This explains why the second option is correct."
            )
        ]
    }
}
