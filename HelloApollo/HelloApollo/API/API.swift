// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class PostAddedSubscription: GraphQLSubscription {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    subscription PostAdded {
      postAdded {
        __typename
        text
        author
      }
    }
    """

  public let operationName: String = "PostAdded"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("postAdded", type: .object(PostAdded.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(postAdded: PostAdded? = nil) {
      self.init(unsafeResultMap: ["__typename": "Subscription", "postAdded": postAdded.flatMap { (value: PostAdded) -> ResultMap in value.resultMap }])
    }

    public var postAdded: PostAdded? {
      get {
        return (resultMap["postAdded"] as? ResultMap).flatMap { PostAdded(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "postAdded")
      }
    }

    public struct PostAdded: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Post"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("text", type: .scalar(String.self)),
        GraphQLField("author", type: .scalar(String.self)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(text: String? = nil, author: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Post", "text": text, "author": author])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var text: String? {
        get {
          return resultMap["text"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "text")
        }
      }

      public var author: String? {
        get {
          return resultMap["author"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "author")
        }
      }
    }
  }
}

public final class PostQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Post {
      posts {
        __typename
        text
        author
      }
    }
    """

  public let operationName: String = "Post"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("posts", type: .list(.object(Post.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(posts: [Post?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "posts": posts.flatMap { (value: [Post?]) -> [ResultMap?] in value.map { (value: Post?) -> ResultMap? in value.flatMap { (value: Post) -> ResultMap in value.resultMap } } }])
    }

    public var posts: [Post?]? {
      get {
        return (resultMap["posts"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Post?] in value.map { (value: ResultMap?) -> Post? in value.flatMap { (value: ResultMap) -> Post in Post(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [Post?]) -> [ResultMap?] in value.map { (value: Post?) -> ResultMap? in value.flatMap { (value: Post) -> ResultMap in value.resultMap } } }, forKey: "posts")
      }
    }

    public struct Post: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Post"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("text", type: .scalar(String.self)),
        GraphQLField("author", type: .scalar(String.self)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(text: String? = nil, author: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Post", "text": text, "author": author])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var text: String? {
        get {
          return resultMap["text"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "text")
        }
      }

      public var author: String? {
        get {
          return resultMap["author"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "author")
        }
      }
    }
  }
}
