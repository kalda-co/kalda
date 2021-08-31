import type { Post, Comment } from "./state"

export function reorderComments(post: Post, commentId: number): Post {
      // REORDER THE COMMENTS
      let postFirstComment = post.comments.find(
        (comment) => comment.id == commentId
      );

      if (postFirstComment) {
        let otherComments = post.comments.filter(
          (comment: Comment) => comment.id != commentId
        );

        let resultComments = [postFirstComment, ...otherComments];

        let orderedPost: Post = {
          id: post.id,
          content: post.content,
          author: post.author,
          comments: resultComments,
        };
        return orderedPost;
      } else {
        return post
      }
    }


export function truncate(content: string): string {
    if (content.length > 30) {
      return content.substring(0, 30) + "...";
    } else {
      return content;
    }
  }
