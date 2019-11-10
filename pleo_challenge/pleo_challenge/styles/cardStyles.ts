import { StyleProp, TextStyle } from "react-native";

export const whiteRoundedCard: StyleProp<TextStyle> = {
    backgroundColor: "white", 
    borderRadius: 12, 
    margin: 20, 
    shadowColor: "black", 
    shadowRadius: 4, 
    shadowOpacity: 0.3, 
    shadowOffset: { width: 0, height: 2 }
}

export const cardContent: StyleProp<TextStyle> = { 
    marginLeft: 12, 
    marginRight: 12, 
    marginTop: 24, 
    marginBottom: 24 
}
